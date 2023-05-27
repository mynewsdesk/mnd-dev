module Mnd
  class Commands::Open < Commands::Base
    summary "Conveniently opens services based on repository context"
    usage <<-EOF
      mnd open buildkite # opens repo/branch in buildkite
      mnd open github # opens repo in github
      mnd open pr # opens pull request for the current branch
      mnd open rollbar # opens repo in rollbar
	  EOF

    def perform
      # ie. "https://github.com/mynewsdesk/mynewsdesk.git\n" -> "mynewsdesk"
      current_repo = File.basename(`git remote get-url origin`).chomp(".git\n")

      if current_repo.empty?
        display.error "Error: Couldn't figure out current repository from remote origin. Perhaps you're not running the command from within a git repository?"
        exit 1
      end

      service = arguments.first?

      unless service
        display.error "Error: You need to provide the name of a service to open, run 'mnd help open' for options"
        exit 1
      end

      current_branch = Mnd::Utils::Git.current_branch

      case service
      when "buildkite"
        system("open https://buildkite.com/mynewsdesk/#{current_repo}/builds?branch=#{current_branch}")
      when "github"
        system("open https://github.com/mynewsdesk/#{current_repo}")
      when "github-actions", "ga", "actions"
        system("open https://github.com/mynewsdesk/#{current_repo}/actions?query=branch:#{current_branch}")
      when "rollbar"
        system("open https://rollbar.com/mynewsdesk/#{current_repo}")
      when "pr"
        system("gh pr view --web || gh pr create --web")
      else
        display.error "Error: Didn't recognize the '#{service}' service, run 'mnd help open' for a list of valid options"
      end
    end
  end
end
