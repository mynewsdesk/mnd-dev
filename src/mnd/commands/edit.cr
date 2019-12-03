module Mnd
  class Commands::Edit < Commands::Base
    summary "Open repo source in editor"
    usage "mnd edit langdetect # open mnd-langdetect source in editor"

    def perform
      if selected_repos.empty?
        display.error "Please specify an available repo to edit"
        return
      end

      unless editor = ENV["EDITOR"]?
        display.error "Can't edit without specifying the EDITOR env variable"
        return
      end

      selected_repos.each do |repo|
        run "#{editor} #{repo.root}"
      end
    end
  end
end
