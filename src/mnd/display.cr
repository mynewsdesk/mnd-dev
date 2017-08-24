require "colorize"

module Mnd
  class Display
    def info(message = "")
      puts message
    end

    def warn(message = "")
      puts message.colorize(:yellow)
    end

    def error(message = "")
      puts message.colorize(:red)
    end

    def debug(message = "")
      puts message.colorize(:dark_gray)
    end

    def header(message)
      info
      info ("=" * 80).colorize(:light_green).mode(:dim)
      info message.colorize(:green)
      info ("=" * 80).colorize(:light_green).mode(:dim)
    end
  end
end
