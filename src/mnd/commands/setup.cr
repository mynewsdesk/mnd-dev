module Mnd
  class Commands::Setup < Commands::Base
    summary "Configures the mnd tool"
    usage "mnd setup # runs step by step configuration"

    def perform
      config = LocalConfig.instance
      default_path = config.root_path? || "~/code"

      display.info "Where do you want to install the mynewsdesk repos?"
      print "root_path: (#{default_path}) "

      answer = gets.to_s.chomp
      path = File.expand_path(answer.presence || default_path)

      if Dir.exists? path
        config.root_path = path
      else
        if yes?("The path #{path} doesn't exist, do you want to create it?")
          begin
            Dir.mkdir_p(path)
            display.info "Directory successfully created!"
          rescue e
            display.error e.message
            exit
          end

          config.root_path = path
        else
          display.error "No root path configured!"
          exit
        end
      end

      config.persist!

      display.info "All done!"
    end

    private def yes?(prompt)
      loop do
        print "#{prompt} [y/n] "
        yes_or_no = gets.to_s

        if yes_or_no[/y/i]?
          return true
        elsif yes_or_no[/n/i]?
          return false
        else
          display.warn "Please answer [y]es or [n]o"
        end
      end
    end
  end
end
