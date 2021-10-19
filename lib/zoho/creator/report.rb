require 'faraday'
require 'addressable'
require_relative '../auth_token'

module Zoho
  module Creator
    class Report
      def initialize(base_url, account_owner, app_name, report_name)
        @report_uri =
          Addressable::URI.parse(
            "https://#{base_url}/api/v2/#{account_owner}/#{app_name}/report/#{report_name}/",
          )
      end

      def export(criteria = {})
        token = AuthToken.new

        response = Faraday.get(
          @report_uri.join('export'),
          { filetype: 'csv', **criteria },
          { Authorization: "Zoho-oauthtoken #{token.access_token}" },
        ) { |req| req.options.on_data = Proc.new { |chunk| $stdout << chunk } }

        if response.status != 200
          raise "Response failed with #{response.status}"
        end
      end
    end
  end
end
