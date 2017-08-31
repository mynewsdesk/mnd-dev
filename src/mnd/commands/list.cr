module Mnd
  class Commands::List < Commands::Base
    summary "List all repos"
    usage "mnd list"

    def perform
      Repo.all.each do |repo|
        if repo.exists?
          display.info "#{repo} [#{repo.root}]"
        else
          display.warn "#{repo} [not installed]"
        end
      end
    end
  end
end
