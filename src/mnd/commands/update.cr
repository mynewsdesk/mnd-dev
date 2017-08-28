require "http/client"

module Mnd
  class Commands::Update < Commands::Base
    summary "Self update"
    usage "mndx update # update itself by downloading the latest release from github"

    def perform
      display.info "Updating mnd..."

      latest_version = get_latest_version_or_exit

      if latest_version.includes? Mnd::VERSION
        display.info "Already using latest version #{Mnd::VERSION}"
        exit
      end

      download_url = "https://github.com/mynewsdesk/mnd-dev/releases/download/#{latest_version}/mnd"
      HTTP::Client.get(download_url) do |response|
        File.write("/usr/local/bin/mnd", response.body_io)
      end

      display.info "Updated to version #{latest_version}"
    end

    private def get_latest_version_or_exit
      response = HTTP::Client.head "https://github.com/mynewsdesk/mnd-dev/releases/latest"
      if location = response.headers["Location"]
        # the latest url redirects to github.com/<user>/<repo>/<releases>/<version>
        location.split("/").last
      else
        display.error "Unexpected response from github: #{response}"
        exit
      end
    end
  end
end
