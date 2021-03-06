module Mnd
  class Commands::Base
    macro inherited
      Commands.register_command({{@type.name.split("::").last.downcase}}, {{@type.name}})
    end

    def self.summary(summary : String? = nil)
      if summary
        @@summary = summary
      else
        @@summary || ""
      end
    end

    def self.usage(usage : String? = nil)
      if usage
        @@usage = usage
      else
        @@usage || ""
      end
    end

    getter :arguments
    getter :selected_repos

    @selected_repos = [] of Repo

    def initialize(arguments = [] of String)
      @arguments = arguments

      @selected_repos = Repo.all.select do |repo|
        arguments.includes?(repo.name) || arguments.includes?(repo.short_name)
      end
    end

    def perform
      display.error "ERROR: implement #perform in your command for great justice!"
      exit
    end

    def run(cmd, repo = nil)
      if repo && !repo.exists?
        display.warn "#{repo} not found, skip #{cmd}"
        return
      end

      ready_cmd = repo.nil? ? cmd : "cd #{repo.root} && #{cmd}"
      display.debug ready_cmd

      system ready_cmd
    end

    def display
      Mnd.display
    end
  end
end
