module Mnd
  class Commands::Platform < Commands::Base
    summary "Get or set the current platform"
    usage <<-EOF
    mnd platform # print the current and available platforms
    mnd platform poptype # set the current platform to poptype
    EOF

    def perform
      if arguments.empty?
        display.info "Current platform: #{LocalConfig.instance.current_platform}"
        display.info
        display.info "Available platforms:"
        available_platforms.each { |platform| display.info platform }
      else
        config = LocalConfig.instance
        desired_platform = arguments.first

        if available_platforms.includes? desired_platform
          config.current_platform = desired_platform
          config.persist!

          display.info "Set current platform to: #{desired_platform}"
        else
          display.error "\nERROR: '#{desired_platform}' is not an available platform"
          display.info
          display.info "Available platforms are:"
          available_platforms.each { |platform| display.info platform }
        end
      end
    end

    private def available_platforms
      Mnd::PLATFORMS.keys
    end
  end
end
