module Mnd
  class Commands::Upgrade < Commands::Base
    summary "Upgrade all or given repos"
    usage <<-EOF
    mnd upgrade # upgrade all repos
    mnd upgrade <repo1> <repo2> # upgrade the given repos
    EOF

    def perform
      repos = selected_repos.presence || Repo.all.select &.exists?

      Utils::Git.verify_clean_repos!(repos)

      Repo.in_each(repos) do |repo|
        display.header "Upgrading #{repo.name}"

        run "git checkout master && git pull --rebase"
        run "bin/update"

        display.info
      end
    end
  end
end
