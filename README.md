# giphylink

An app that fetches gifs from giphy and generates a shortlink to them.

## Overview

This app was written to showcase connecting monoliths to microservices using Consul DNS interface.
It was showcased at a talk given on Consul - "Bridging Past, Present, and Future infrastructure with Consul" at [DevOps Barcelona](https://devops.barcelona/).

## Usage 

```bash
gem install bundler
```

```bash
bundle install
```

Set environment variables

```bash
export GIPHY_API_KEY="API_KEY_HERE"
```

*Optionally* set redis password.

```bash
export REDIS_PASSWORD="REDIS_PASSWORD_HERE"
```

Run application

```bash
ruby app.rb
```

Open in browser

```bash
curl localhost:4567
```
