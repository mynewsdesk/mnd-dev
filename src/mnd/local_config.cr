require "yaml"

DEFAULT_CONFIG = {
  "current_platform" => "prime",
}

module Mnd
  class LocalConfig
    INSTANCE = new
    DOT_FILE_PATH = ENV.fetch("HOME") + "/.mnd-dev"

    def self.instance
      INSTANCE
    end

    def initialize
      if File.exists? dot_file
        @config = Hash(String, String).from_yaml(File.read(dot_file))
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

    def persist!
      File.write dot_file, @config.to_yaml
    end

    private def dot_file
      DOT_FILE_PATH
    end
  end
end
