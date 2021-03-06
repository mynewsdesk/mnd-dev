module Mnd
  class Commands::Install < Commands::Base
    summary "Install missing repos"
    usage <<-EOF
    mnd install # Install and setup missing repos
    mnd install mynewsdesk # Only install mynewsdesk
    EOF

    def perform
      if arguments.size != selected_repos.size
        not_repos = arguments - selected_repos.map &.name
        plural = not_repos.size > 1
        display.error "Repo#{'s' if plural} not found: #{not_repos.join(", ")}"
        return
      end

      repos = selected_repos.presence || Repo.all
      uninstalled_repos = repos.reject &.exists?

      if uninstalled_repos.empty?
        display.info "All repos are already installed!"
        return
      end

      uninstalled_repos.each do |repo|
        display.header "Installing #{repo.name}"

        run "cd #{LocalConfig.instance.root_path} && git clone #{repo.git}"

        if File.exists? "#{repo.root}/bin/setup"
          run "bin/setup", repo
        else
          display.info "Setup skipped (no bin/setup script available)"
        end

        display.info
      end
    end
  end
end
