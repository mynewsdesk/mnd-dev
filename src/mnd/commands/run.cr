module Mnd
  class Commands::Run < Commands::Base
    summary "Run shell commands on multi-repos"
    usage <<-EOF
    mndx run "bundle install" # run bundle install on all repos
    mndx run web create "bundle update" # run on mndx-web and mndx-create
    EOF

    def perform
      if arguments.empty?
        display.error "Missing command to run"
        return
      end

      repos = selected_repos.presence || Repo.all
      command = arguments.join " "

      repos.each do |repo|
        display.header repo

        run command, repo
      end
    end
  end
end
