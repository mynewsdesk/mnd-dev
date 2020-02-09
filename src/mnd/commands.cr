require "./commands/base"
require "./commands/*"
require "./commands/gdpr/*"

module Mnd
  module Commands
    def self.commands
      @@commands ||= {} of String => Commands::Base.class
    end

    def self.find_command(command_name)
      if command = commands.find { |name, klass| name == command_name }
        command[1]
      end
    end

    def self.register_command(command_name, command_class)
      commands[command_name] = command_class
    end

    def self.run(command_name, args)
      if command = find_command(command_name)
        command.new(args).perform
      else
        Mnd.display.error "No command named '#{command_name}'"
        Mnd.display.info
        Mnd.display.info "Running 'mnd help' might ease your pain"
      end
    end
  end
end
