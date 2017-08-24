require "./patches/*"

require "./mnd/utils/*"
require "./mnd/repo"
require "./mnd/display"
require "./mnd/cli"

module Mnd
  ROOT_PATH = File.expand_path("../../", __FILE__)

  def self.root
    ROOT_PATH
  end

  def self.display
    @@display ||= Display.new
  end
end

Mnd::CLI.start(ARGV)
