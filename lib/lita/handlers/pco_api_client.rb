require 'oauth2'
require 'pco_api'
require 'launchy'

module Lita
  module Handlers
    class PcoApiClient < Handler
      config :oauth_app_id, default: ENV['OAUTH_APP_ID']
      config :oauth_secret, default: ENV['OAUTH_SECRET']
      config :api_url, default: ENV['API_URL']
      config :scope, default: 'resources'

      http.get '/auth/complete', :respond_with_auth_complete

      def client
        OAuth2::Client.new(config.oauth_app_id, config.oauth_secret, site: config.api_url)
      end

      route(/authorize/i, :respond_with_authorize, command: true)

      def respond_with_authorize(response)
        response.reply 'You are being redirected to PCO where you will be asked to authorize this app...'
        url = client.auth_code.authorize_url(
          scope: config.scope,
          redirect_uri: 'http://localhost:8080/auth/complete'
        )
        Launchy.open(url)
      end


      def respond_with_auth_complete(request, response)
        # TODO: extract code and finish authorization
        code = request.params
        response.write "#{code['code']}"
      end
      Lita.register_handler(self)
    end
  end
end
