require "yaml"

DEFAULT_CONFIG = {
  "current_platform" => "prime",
}

module Mnd
  class LocalConfig
    INSTANCE = new
    DOT_FILE_PATH = ENV.fetch("HOME") + "/.mnd"

    def self.instance
      INSTANCE
    end

    def initialize
      if File.exists? DOT_FILE_PATH
        @config = Hash(String, String).from_yaml(File.read(DOT_FILE_PATH))
      else
        @config = DEFAULT_CONFIG.dup
        persist!
      end
    end

    def current_platform
      @config["current_platform"]
    end

    def current_platform=(platform)
      @config["current_platform"] = platform
    end

    def root_path?
      @config["root_path"]?
    end

    def root_path
      @config["root_path"]? || require_setup!
    end

    def root_path=(root)
      @config["root_path"] = root
    end

    def buildkite_api_token?
      @config["buildkite_api_token"]?
    end

    def buildkite_api_token
      @config["buildkite_api_token"]
    end

    def buildkite_api_token=(buildkite_api_token)
      @config["buildkite_api_token"] = buildkite_api_token
    end

    def mixpanel_oauth_token
     @config["mixpanel_oauth_token"]
    end

    def mixpanel_oauth_token?
     @config["mixpanel_oauth_token"]?
    end

    def mixpanel_oauth_token=(token)
     @config["mixpanel_oauth_token"] = token
    end

    def mixpanel_organization_project_api_secret_token
     @config["mixpanel_organization_project_api_secret_token"]
    end

    def mixpanel_organization_project_api_secret_token?
     @config["mixpanel_organization_project_api_secret_token"]?
    end

    def mixpanel_organization_project_api_secret_token=(token)
     @config["mixpanel_organization_project_api_secret_token"] = token
    end

    def mixpanel_organization_project_api_project_token
     @config["mixpanel_organization_project_api_project_token"]
    end

    def mixpanel_organization_project_api_project_token?
     @config["mixpanel_organization_project_api_project_token"]?
    end

    def mixpanel_organization_project_api_project_token=(token)
     @config["mixpanel_organization_project_api_project_token"] = token
    end

    def mixpanel_user_project_api_secret_token
     @config["mixpanel_user_project_api_secret_token"]
    end

    def mixpanel_user_project_api_secret_token?
     @config["mixpanel_user_project_api_secret_token"]?
    end

    def mixpanel_user_project_api_secret_token=(token)
     @config["mixpanel_user_project_api_secret_token"] = token
    end

    def mixpanel_user_project_api_project_token
     @config["mixpanel_user_project_api_project_token"]
    end

    def mixpanel_user_project_api_project_token?
     @config["mixpanel_user_project_api_project_token"]?
    end

    def mixpanel_user_project_api_project_token=(token)
     @config["mixpanel_user_project_api_project_token"] = token
    end

    def persist!
      File.write DOT_FILE_PATH, @config.to_yaml
    end

    private def require_setup!
      Mnd.display.error "Please run 'mnd setup' to initialize your configuration file before use"
      exit
    end
  end
end
