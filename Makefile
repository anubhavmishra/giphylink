.DEFAULT_GOAL := help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean the project
	rm giphylink.tar.gz

run: ## Run the project
	ruby app.rb &

release: ## Create a tar.gz file for release
	tar cjv --exclude .git -f /tmp/giphylink.tar.gz .