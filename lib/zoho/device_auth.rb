require 'json'
require 'faraday'
require 'faraday_middleware'
require 'addressable'
require_relative './auth_token'

module Zoho
  class DeviceAuth
    AUTH_DOMAIN_PATH = 'https://accounts.zoho.com'
    DEVICE_AUTH_ENDPOINT = '/oauth/v3/device/code'
    DEVICE_TOKEN_ENDPOINT = '/oauth/v3/device/token'

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret

      start
    end

    def start
      uri = device_auth_uri
      uri.query_values = {
        client_id: @client_id,
        grant_type: 'device_request',
        scope:
          'ZohoCreator.meta.READ,ZohoCreator.data.READ,ZohoCreator.meta.CREATE,ZohoCreator.data.CREATE',
        access_type: 'offline'
      }

      result = Faraday.post(uri)
      @auth_request = JSON.parse(result.body, symbolize_names: true)

      prompt_user
    end

    def prompt_user
      puts "Please navigate to #{@auth_request[:verification_url]} and provide the code #{@auth_request[:user_code]}"

      while poll_request
        print '.'
        sleep(2)
      end

      puts
    end

    def store_token(response)
      puts 'Saving token...'

      AuthToken.save_token(response)
    end

    def poll_request
      uri = device_token_uri
      uri.query_values = {
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: 'device_token',
        code: @auth_request[:device_code]
      }

      result = Faraday.post(uri)
      response = JSON.parse(result.body, symbolize_names: true)

      case response
      in access_token: String
        store_token(response)
        return false
      in error: 'authorization_pending'
        return true
      in error: 'slow_down'
        return true
      else
        raise "Zoho returned error #{response[:error]}"
      end
    end

    def device_auth_uri
      Addressable::URI.join(AUTH_DOMAIN_PATH, DEVICE_AUTH_ENDPOINT)
    end

    def device_token_uri
      Addressable::URI.join(AUTH_DOMAIN_PATH, DEVICE_TOKEN_ENDPOINT)
    end
  end
end
