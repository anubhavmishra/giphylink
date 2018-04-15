require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'redis'
require 'net/http'
require 'json'

# Set server bind address and port
set :bind, '0.0.0.0'
set :port, 8080

redis_password = ENV["REDIS_PASSWORD"]
if redis_password.to_s.empty?
  redis = Redis.new
else
  # Use local redis-server
  redis = Redis.new(url: "redis://:#{redis_password}@localhost/")
  # Create redis client using redis-server
  #redis = Redis.new(url: "redis://:#{redis_password}@giphylink-db.service.consul/")
end
 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
 
  def random_string(length)
    rand(36**length).to_s(36)
  end
end 

def get_image(keyword) 
  giphy_api_key = ENV["GIPHY_API_KEY"]
  puts giphy_api_key
  giphy_search_url = "http://api.giphy.com/v1/gifs/search"
  
  # Create giphy api search url
  url = "#{giphy_search_url}?q=#{keyword}&api_key=#{giphy_api_key}&limit=5"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer)
  gif_data = result["data"][0]
  return gif_data["embed_url"], gif_data["url"]
end

def get_image_search_service(keyword) 
  image_search_url = "http://image-search.service.consul"
  
  # Create giphy api search url
  url = "#{image_search_url}?q=#{keyword}"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer)
  return result["embed_url"], result["url"]
end
 
get '/' do
  erb :index
end
 
post '/' do
  if params[:keyword] and not params[:keyword].empty?

    # Get image using giphy directly
    @image_url, @link_url = get_image params[:keyword]

    # Get image using image search
    # Uncomment when using image-search service to retrive image links
    # Comment line 65 after.
    #@image_url, @link_url = get_image_search_service params[:keyword]

    # Generate shortcode and store it in the database
    @shortcode = random_string 5
    redis.setnx "links:#{@shortcode}", @image_url

  end
  erb :index
end
 
get '/:shortcode' do
  @url = redis.get "links:#{params[:shortcode]}"
  redirect @url || '/'
end
