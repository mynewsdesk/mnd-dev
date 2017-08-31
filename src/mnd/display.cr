require "colorize"

module Mnd
  class Display
    def info(message = "")
      puts message.to_s
    end

    def warn(message = "")
      puts message.to_s.colorize(:yellow)
    end

    def error(message = "")
      puts message.to_s.colorize(:red)
    end

    def debug(message = "")
      puts message.to_s.colorize(:dark_gray)
    end

    def header(message)
      info
      info ("=" * 80).colorize(:light_green).mode(:dim)
      info message.to_s.colorize(:green)
      info ("=" * 80).colorize(:light_green).mode(:dim)
    end
  end
end
