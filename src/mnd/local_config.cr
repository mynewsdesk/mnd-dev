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

    def github_api_token?
      @config["github_api_token"]?
    end

    def github_api_token
      @config["github_api_token"]
    end

    def github_api_token=(github_api_token)
      @config["github_api_token"] = github_api_token
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
