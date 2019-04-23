require "http/client"

module Mnd
  class Commands::Update < Commands::Base
    summary "Self update"
    usage "mnd update # update itself reinstalling from HEAD"

    def perform
      display.info "Updating mnd..."

      run "brew reinstall mnd"
    end
  end
end
