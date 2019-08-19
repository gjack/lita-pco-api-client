# lita-pco-api-client

[![Build Status](https://travis-ci.org/gjack/lita-pco-api-client.png?branch=master)](https://travis-ci.org/gjack/lita-pco-api-client)
[![Coverage Status](https://coveralls.io/repos/gjack/lita-pco-api-client/badge.png)](https://coveralls.io/r/gjack/lita-pco-api-client)

A Lita handler to interact with Planning Center API via OAuth2.

## Installation

Add lita-pco-api-client to your Lita instance's Gemfile:

```ruby
gem "lita-pco-api-client"
```

## Configuration

Visit https://api.planningcenteronline.com/oauth/applications to create an OAuth application token.

In your Lita robot you will need to configure the following:

```ruby
Lita.configure do |config|
  .
  .
  .

  config.handlers.pco_api_client.oauth_app_id = <your CLIENT_ID>
  config.handlers.pco_api_client.oauth_secret = <your CLENT_SECRET>
  config.handlers.pco_api_client.api_url = 'https://api.planningcenteronline.com'
  config.handlers.pco_api_client.scope = 'resources'
  config.handlers.pco_api_client.host_url = <your robot host url>
end
```

## Usage

The handler responds to the `:connected` event by verifying that a valid access token exists and, if it doesn't, attempting to authorize the application.
