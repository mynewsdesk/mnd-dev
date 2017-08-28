module Mnd
  class Commands::Install < Commands::Base
    summary "Install missing repos"
    usage "mnd install # Install and setup missing repos"

    def perform
      repos = Repo.all.reject &.exists?

      if repos.empty?
        display.info "All repos are already installed!"
        return
      end

      repos.each do |repo|
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
