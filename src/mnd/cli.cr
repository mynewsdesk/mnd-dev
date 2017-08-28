require "./commands"

class Mnd::CLI
  def self.start(args)
    if %w[-v -version --version].includes? args.join
      Mnd.display.info Mnd::VERSION
      exit
    end

    command = args.shift.strip rescue "help"

    Mnd::Commands.run(command, args)
  end
end
