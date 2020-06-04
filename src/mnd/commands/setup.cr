module Mnd
  class Commands::Setup < Commands::Base
    summary "Configures the mnd tool"
    usage "mnd setup # runs step by step configuration"

    def perform
      check_prerequisites!

      config = LocalConfig.instance
      default_path = config.root_path? || "#{ENV.fetch("HOME")}/code"

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

    private def check_prerequisites!
      # enforce rbenv has been initialized
      unless `which ruby`.includes?("rbenv")
        display.error "ERROR: Looks like you haven't initialized rbenv properly."
        display.error "Check out the 'Configure rbenv' section of the dev-computer README:"
        display.error "https://github.com/mynewsdesk/dev-computer"
        abort
      end

      # enforce heroku cli installed
      unless system("which heroku > /dev/null")
        display.error "ERROR: Looks like you haven't installed the heroku CLI."
        display.error "Please run the dev-computer install script to install all prerequisites."
        abort
      end

      # enforce heroku cli is logged in
      unless system("heroku auth:whoami &> /dev/null")
        display.error "ERROR: You are not logged in to heroku. Please run 'heroku login' to login."
        abort
      end

      # enforce heroku access to mynewsdesk organization
      unless `heroku orgs`.includes?("mynewsdesk")
        display.error "ERROR: Your heroku user doesn't have access to the mynewsdesk organization."
        display.error "Please ask your Team Lead or local DevOps dude to hook you up."
        abort
      end
    end

    private def abort
      exit 1
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
