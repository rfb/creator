module Zoho
  class AuthToken
    extend Forwardable
    attr_reader :access_token, :refresh_token

    TOKEN_PATH = File.expand_path('~/.zoho_token.json')

    def initialize
      load_token!
    end

    def load_token!
      token = JSON.parse(File.read(TOKEN_PATH))
      @access_token = token['access_token']
      @refresh_token = token['refresh_token']
      @api_domain = token['api_domain']
      @token_type = token['token_type']
      @expires_in = token['expires_in']
    end

    def self.save_token(token)
      File.open(TOKEN_PATH, 'w', 0600) { |file| file.write(JSON.dump(token)) }
    end
  end
end
