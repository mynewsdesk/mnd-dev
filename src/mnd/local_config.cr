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
      if File.exists? dot_file
        @config = Hash(String, String).from_yaml(File.read(dot_file))
      else
        Mnd.display.error "Please run 'mnd setup' to initialize your configuration file before use"
        exit
      end
    end

    def current_platform
      @config["current_platform"]
    end

    def current_platform=(platform)
      @config["current_platform"] = platform
    end

    def root_path
      @config["root_path"]
    end

    def root_path=(root)
      @config["root_path"] = root
    end

    def persist!
      File.write dot_file, @config.to_yaml
    end

    private def dot_file
      DOT_FILE_PATH
    end
  end
end
