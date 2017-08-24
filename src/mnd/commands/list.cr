module Mnd
  class Commands::List < Commands::Base
    summary "List all repos"
    usage "mnd list"

    def perform
      Repo.all.each do |repo|
        if repo.exists?
          display.info "#{repo.name} [#{repo.root}]"
        else
          display.warn "#{repo.name} [not installed]"
        end
      end
    end
  end
end
