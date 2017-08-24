require "./commands"

class Mnd::CLI
  #extend Mndx::Helpers

  def self.start(args)
    #$stdin.sync = true if $stdin.isatty
    #$stdout.sync = true if $stdout.isatty
    command = args.shift.strip rescue "help"
    # Mnd::Commands.load
    # Mnd::Commands.run(command, args)
    Mnd::Commands.run(command, args)
  end
end
