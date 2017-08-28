require "./patches/*"

require "./mnd/version"
require "./mnd/utils/*"
require "./mnd/repo"
require "./mnd/display"
require "./mnd/cli"

module Mnd
  def self.display
    @@display ||= Display.new
  end
end

Mnd::CLI.start(ARGV)
