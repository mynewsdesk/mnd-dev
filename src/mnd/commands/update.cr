require "http/client"

module Mnd
  class Commands::Update < Commands::Base
    summary "Self update"
    usage "mndx update # update itself reinstalling from HEAD"

    def perform
      display.info "Updating mnd..."

      run "brew reinstall --HEAD mynewsdesk/tap/mnd"
    end
  end
end
