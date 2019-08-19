require 'oauth2'
require 'pco_api'
require 'launchy'
require 'time'

module Lita
  module Handlers
    class PcoApiClient < Handler
      config :oauth_app_id, default: ENV['OAUTH_APP_ID']
      config :oauth_secret, default: ENV['OAUTH_SECRET']
      config :api_url, default: ENV['API_URL']
      config :scope, default: 'resources'
      config :host_url, default: ENV['HOST_URL']

      TOKEN_EXPIRATION_PADDING = 300

      http.get '/auth/complete', :respond_with_auth_complete

      def client
        OAuth2::Client.new(config.oauth_app_id, config.oauth_secret, site: config.api_url)
      end

      def api
        PCO::API.new(oauth_access_token: token.token, url: config.api_url)
      end

      def token
        auth_token = redis.get('token')
        return if auth_token.nil?
        token = OAuth2::AccessToken.from_hash(client, JSON.parse(auth_token).dup)
        if token.expires? && (token.expires_at < Time.now.to_i + TOKEN_EXPIRATION_PADDING) && token.refresh_token
        # looks like our token will expire soon and we have a refresh token,
        # so let's get a new access token
        token = token.refresh!
        redis.set('token', JSON.dump(token.to_hash))
        end
        token
      rescue OAuth2::Error
        # our token info is bad, let's start over
        redis.del('token')
      end

      on(:connected) do |payload|
        target = Source.new(room: "##{payload[:room]}")
        if token.nil?
          robot.send_message(target, "You need to authorize the app before you can begin")
          authorize_app
        else
          robot.send_message(target, "App authorized and ready to go!")
        end
      end

      route(
        /authorize/i,
        :respond_with_authorize,
        command: true,
        help: {
          'authorize' => 'Authorize use of the application'
          }
        )

      def authorize_app
        url = client.auth_code.authorize_url(
          scope: config.scope,
          redirect_uri: "#{config.host_url}/auth/complete"
        )

        Launchy.open(url)
      end

      def respond_with_authorize(response)
        response.reply 'You are being redirected to PCO where you will be asked to authorize this app...'
        authorize_app
      end

      def respond_with_auth_complete(request, response)
        code = request.params['code']
        auth_token = client.auth_code.get_token(
          request.params['code'],
          redirect_uri: "#{config.host_url}/auth/complete"
        )

        redis.set('token', JSON.dump(auth_token.to_hash))
        # should redirect to some info page
        response.write("You are all set and ready to go!")
      end

      Lita.register_handler(self)
    end
  end
end
