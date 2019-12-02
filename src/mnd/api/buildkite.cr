require "json"
require "http/client"

module Mnd::Api
  module Buildkite
    BASE_URL = "https://api.buildkite.com/v2"

    def self.request(method, path, params = nil)
      ensure_buildkite_api_token!

      HTTP::Client.exec(
        method,
        "#{BASE_URL}/#{path}",
        headers: HTTP::Headers{
          "Authorization" => "Bearer #{LocalConfig.instance.buildkite_api_token}",
          "Content-Type" => "application/json",
          "Accept" => "application/json",
        },
        body: params ? params.to_json : nil,
      )
    end

    def self.get_pipeline(pipeline_slug)
      response = request("GET", "organizations/mynewsdesk/pipelines/#{pipeline_slug}")

      JSON.parse(response.body)
    end

    def self.create_build(pipeline_slug, branch, deployment_target)
      response = request(
        "POST",
        "organizations/mynewsdesk/pipelines/#{pipeline_slug}/builds",
        params: {
          commit: "HEAD",
          branch: branch,
          env: {
            DEPLOYMENT_TARGET: deployment_target,
          }
        }
      )

      JSON.parse(response.body)
    end

    def self.ensure_buildkite_api_token!
      prompt_for_buildkite_api_token unless LocalConfig.instance.buildkite_api_token?
    end

    def self.prompt_for_buildkite_api_token
      Mnd.display.info "Please copy / paste the Buildkite user's API Token from 1password to continue."

      config = LocalConfig.instance

      print "Buildkite API Token: "
      config.buildkite_api_token = gets.to_s.chomp

      test_request_response = request("GET", "user")

      if test_request_response.status_code == 200
        config.persist!
      else
        Mnd.display.info ""
        Mnd.display.error "You provided the API Token '#{config.buildkite_api_token}' but the request to Buildkite's API failed. Maybe you provided the wrong token?"
        Mnd.display.error "The response from Buildkite's API had status '#{test_request_response.status_code}' and body:"
        Mnd.display.error test_request_response.body
        Mnd.display.info "Please run the command again to try again."

        exit 1
      end
    end
  end
end
