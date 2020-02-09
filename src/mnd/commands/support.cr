require "option_parser"

module Mnd
  class Commands::Support < Commands::Base
    # The summary is one short sentence, which will appear in the help page
    # The usage is the details, which will appear when running 'mnd help awesome'
    summary "Support/data utils"
    usage <<-EOF
    Support Utils for data management and multirepo tasks e.g. GDPR cleanse, data export, etc.

    mnd support # list of commands to select from, further arguments are chosen interactively
    mnd support command # TODO: help on a specific command
    mnd support command argument1 argument2 # Shortcuts, dependent on command. Please refer to each command's help
    mnd support --dry-run # Runs in dry-run mode only
    EOF

    # The command executes via the perform method
    def perform
      dry_run = false

      option_parser = OptionParser.parse do |parser|
        parser.on "--dry-run", "Dry run" do
          dry_run = true
        end
      end

      # Collecting required arguments
      # Type of support task
      action = arguments.size > 0 && arguments[0]

      unless action
        display.info "Which support task would you like to perform?"
        display.info "1. GDPR (Data export request) [gdpr-export]"
        display.info "2. GDPR (Data erasure process) [gdpr-delete]"

        confirmation = gets.to_s
        if confirmation[/^1|gdpr-export$/i]?
          action = "gdpr-export"
        elsif confirmation[/^2|gdpr-delete$/i]?
          action = "gdpr-delete"
        end
      end

      case action
        when "gdpr-export"
          display.warn "Not yet implemented."
        when "gdpr-delete"
          Commands::Support::Gdpr::Delete.new(arguments, dry_run).perform
        else
          display.info "Doing nothing"
        exit
      end
    end
  end
end




