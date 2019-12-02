module Mnd::Utils
  module Git
    def self.clean?(dir = Dir.pwd)
      status = `cd #{dir} && git status --porcelain`

      !status.lines.find do |line|
        line.strip[/^[MDA]/]? # dirty files are "M"odified, "D"eleted or "A"dded
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

        exit 1
      end
    end

    # Assuming we're inside a git repo this will match a local branch name with
    # branches on the default remote server to ensure they're up to date.
    def self.verify_remote_branch_up_to_date!(branch)
      # Example STDOUT of ls-remote:
      # 867907262d623e3632b41808617bee5f9c5ac2d2  refs/heads/<branch-name>
      # 8b4428eb9db3e679da599bb580706e6828eecee9  refs/heads/master
      remote_info = `git ls-remote --heads | grep -e "heads/#{branch}$"`.chomp

      if remote_info.empty?
        Mnd.display.error "Error: The branch '#{branch}' doesn't exist in the remote git repo. Run 'git push' on the branch and try again."
        exit 1
      else
        remote_sha = remote_info.split(/\s/).first
        local_sha = `git rev-parse #{branch}`.chomp

        unless remote_sha == local_sha
          Mnd.display.error "Error: Your local '#{branch}' branch doesn't appear to be up to be in sync with the remote branch. Did you forget to 'git push' or 'git pull --rebase'?"
          exit 1
        end
      end
    end

    # String with current branch or nil if not inside a git repo
    def self.current_branch
      # Would love to use 'git branch --show-current' instead but would silently fail on Git version < 2.22
      `git rev-parse --abbrev-ref HEAD`.chomp.presence
    end
  end
end
