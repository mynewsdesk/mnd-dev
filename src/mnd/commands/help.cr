module Mnd
  class Commands::Help < Commands::Base
    summary "Helps you out!"

    def perform
      if command_name = arguments.last?
        if command = Commands.find_command(command_name)
          display.info command.summary
          display.info
          display.info "Usage:"
          display.info command.usage
        else
          display.info "No command matches '#{command_name}'"
        end
      else
        display.info <<-EOF
        Usage: mnd COMMAND [repo1 repo2] [command-specific-options]

        Type 'mnd help COMMAND' for details of each command
        EOF
        display.info
        display.info "Available commands:"
        Commands.commands.each do |name, klass|
          display.info sprintf("%-15s %s", name, klass.summary)
        end
      end
    end
  end
end
