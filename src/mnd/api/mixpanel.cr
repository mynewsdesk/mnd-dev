require "base64"
require "json"
require "http/client"
require "http/params"

module Mnd::Api
  module Mixpanel
    BASE_URL = "www.mixpanel.com"

    def self.get_user(auth_token, email)
      ensure_mixpanel_api_token!

      params = HTTP::Params.encode(
        {
          where: "properties[\"$email\"]==\"#{email}\"",
          output_properties: "[\"$email\"]",
          include_all_users: "true",
          limit: "1000",
        }
      )

      response = HTTP::Client.exec(
        "GET",
        "https://mixpanel.com/api/2.0/engage?#{params}",
        headers: HTTP::Headers{
          "Authorization" => "Basic #{Base64.strict_encode("#{auth_token}:#{nil}")}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
      )

      JSON.parse(response.body)
    end

    def self.request_deletion(auth_token, user_ids)
      ensure_mixpanel_api_token!

      params = {
          token: "#{auth_token}",
          distinct_ids: user_ids,
        }

      response = HTTP::Client.exec(
        "POST",
        "https://mixpanel.com/api/app/data-deletions/v2.0/",
        body: params.to_json,
        headers: HTTP::Headers{
          "Authorization" => "Bearer #{LocalConfig.instance.mixpanel_oauth_token}",
          "Content-Type" => "application/json",
        },
      )

      JSON.parse(response.body)
    end

    private def self.ensure_mixpanel_api_token!
      unless LocalConfig.instance.mixpanel_oauth_token? || LocalConfig.instance.mixpanel_organization_project_api_secret_token? || LocalConfig.instance.mixpanel_organization_project_api_project_token? || LocalConfig.instance.mixpanel_user_project_api_project_token? || LocalConfig.instance.mixpanel_user_project_api_secret_token?
        prompt_for_mixpanel_api_tokens
      end
    end

    private def self.prompt_for_mixpanel_api_tokens
      Mnd.display.info "Please copy / paste the Mixpanel user's API Token from 1password and Mixpanel to continue."

      config = LocalConfig.instance

      Mnd.display.info "Organization Secret Token (find it in Project Settings, api_secret for the project):"
      config.mixpanel_organization_project_api_secret_token = gets.to_s.chomp
      Mnd.display.info "Organization Project Token (find it in Project Settings, token for the project):"
      config.mixpanel_organization_project_api_project_token = gets.to_s.chomp
      Mnd.display.info "User Project Secret Token (find it in Project Settings, api_secret for the project):"
      config.mixpanel_user_project_api_secret_token = gets.to_s.chomp
      Mnd.display.info "User Project Token (find it in Project Settings, token for the project):"
      config.mixpanel_user_project_api_project_token = gets.to_s.chomp
      Mnd.display.info "User Oauth Token (find it in Profile&Preferences / Data & Privacy / GDPR API / OAuth Token for GDPR APIs):"
      config.mixpanel_oauth_token = gets.to_s.chomp

      if config.persist!
        Mnd.display.info "Ok, stored."
      else
        exit 1
      end
    end
  end
end
