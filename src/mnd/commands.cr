require "./commands/base"
require "./commands/*"

module Mnd
  module Commands
    def self.commands
      @@commands ||= {} of String => Commands::Base.class
    end

    def self.register_command(command_name, command_class)
      commands[command_name] = command_class
    end

    def self.run(command_name, args)
      command = commands.find do |name, klass|
        name == command_name
      end

      if command
        command[1].new(args).perform
      else
        Mnd.display.error "No command named '#{command_name}'"
        Mnd.display.info
        Mnd.display.info "Running 'mnd help' might ease your pain"
      end
    end
  end
end
