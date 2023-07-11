require "json"
require "http/client"

module Mnd::Api
  module Github
    BASE_URL = "https://api.github.com"

    def self.request(method, path, params = nil)
      ensure_github_api_token!

      HTTP::Client.exec(
        method,
        "#{BASE_URL}/#{path}",
        headers: HTTP::Headers{
          "Authorization" => "Bearer #{LocalConfig.instance.github_api_token}",
          "Content-Type" => "application/json",
          "Accept" => "application/vnd.github.v3+json",
        },
        body: params ? params.to_json : nil,
      )
    end

    def self.workflow_dispatch!(owner, repository, workflow_id, ref, inputs = nil)
      response = request(
        "POST",
        "repos/#{owner}/#{repository}/actions/workflows/#{workflow_id}/dispatches",
        {
          ref: ref,
          inputs: inputs,
        },
      )

      unless response.success?
        Mnd.display.error "Failed to trigger workflow '#{workflow_id}' for repository '#{owner}/#{repository}' with ref '#{ref}'"
        Mnd.display.error "Response status: #{response.status_code}"
        Mnd.display.error "Response body: #{response.body}"
        exit 1
      end
    end

    private def self.ensure_github_api_token!
      prompt_for_github_api_token unless LocalConfig.instance.github_api_token?
    end

    private def self.prompt_for_github_api_token
      Mnd.display.info "Please copy / paste your GitHub user's Personal Access Token to continue. If you don't have an existing PAT, generate a new one at https://github.com/settings/tokens/new with the 'repo' scope and 'no expiration' to avoid having to re-configure the token in the future."

      config = LocalConfig.instance

      print "GitHub API Token: "
      config.github_api_token = gets.to_s.chomp

      test_request_response = request("GET", "user")

      if test_request_response.status_code == 200
        config.persist!
      else
        Mnd.display.info ""
        Mnd.display.error "You provided the API Token '#{config.github_api_token}' but the request to github's API failed. Maybe you provided the wrong token?"
        Mnd.display.error "The response from github's API had status '#{test_request_response.status_code}' and body:"
        Mnd.display.error test_request_response.body
        Mnd.display.info "Please run the command again to try again."

        exit 1
      end
    end
  end
end