require "./local_config"
require "./platforms"

module Mnd
  class Repo
    def self.all
      platform = LocalConfig.instance.current_platform

      PLATFORMS[platform]
    end

    # loop over repositories, change working dir, and yield repo
    def self.in_each(repos = all)
      repos.each do |repo|
        Dir.cd(repo.root) do
          yield repo
        end
      end
    end

    getter :name
    getter :color
    getter :alias

    def initialize(@name : String, @color : Symbol? = nil, @alias : String? = nil)
    end

    def exists?
      Dir.exists? root
    end

    def root
      @root ||= File.join File.expand_path("../", Mnd.root), name
    end

    def short_name
      @alias || @name.split("-").last
    end

    def git
      "https://github.com/mynewsdesk/#{name}.git"
    end
  end
end
