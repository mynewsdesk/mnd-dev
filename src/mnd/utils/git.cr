module Mnd::Utils
  module Git
    def self.clean?(dir = Dir.pwd)
      status = `cd #{dir} && git status --porcelain`

      !status.lines.find do |line|
        line.strip[/^[MDA]/] # dirty files are "M"odified, "D"eleted or "A"dded
      end
    end

    def self.dirty?(dir = Dir.pwd)
      !clean?(dir)
    end

    def self.verify_clean_repos!(repos)
      dirty_repos = repos.select { |repo| dirty?(repo.root) }

      if dirty_repos.any?
        Mnd.display.error "Error: The following repos don't have a clean working dir:"
        Mnd.display.error dirty_repos.map(&.to_s).join("\n")
        Mnd.display.error "Please stash changes and run command again"

        exit
      end
    end
  end
end
