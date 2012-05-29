require 'faraday'
require 'forwardable'

module FaradayMiddleware
  # Public: A simple middleware that adds an access token to each request.
  #
  # The token is added "Authorization" HTTP request header.
  #
  # Examples
  #
  #   # configure default token:
  #   OAuth2.new(app, 'abc123')
  class OAuth2 < Faraday::Middleware

    AUTH_HEADER = 'Authorization'.freeze

    extend Forwardable
    def_delegators :'Faraday::Utils', :parse_query, :build_query

    def call(env)
      if !@token.empty?
        env[:request_headers][AUTH_HEADER] ||= %(Token token="#{@token}")
      end

      @app.call env
    end

    def initialize(app, token = nil, options = {})
      super(app)
      options, token = token, nil if token.is_a? Hash
      @token = token && token.to_s
    end

  end
end

# deprecated alias
Faraday::Request::OAuth2 = FaradayMiddleware::OAuth2
