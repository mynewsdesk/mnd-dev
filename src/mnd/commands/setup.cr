module Mnd
  class Commands::Setup < Commands::Base
    summary "Configures the mnd tool"
    usage "mnd setup # runs step by step configuration"

    def perform
      config = LocalConfig.instance

      display.info "Where do you want to install the mynewsdesk repos?"
      loop do
        print "root_path: (#{Dir.current}) "
        answer = File.expand_path gets.not_nil!.chomp

        if Dir.exists? answer
          config.root_path = answer
          break
        else
          display.error "The path #{answer} doesn't exist, please provide an existing directory"
        end
      end

      config.persist!

      display.info "All done!"
    end
  end
end
