require "../../api/mixpanel"
require "json"
require "http/client"
require "option_parser"

module Mnd
  class Commands::Support::Gdpr::Delete < Commands::Base
    @dry_run : Bool = false

    def initialize(args, dry_run = false)
      @dry_run = dry_run
      super(args)
    end

    def perform
      # Collecting required arguments

      # email addresses
      emails = [] of String

      unless arguments.size > 1 && arguments[1]
        display.info "Which email addresses? (one per line - double return to end - paste allowed)"
        while
          confirmation = gets
          break if confirmation.blank?

          email = confirmation[/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i]?
          if email.nil?
            display.warn "Invalid email. Any other?"
            next
          end

          emails << "#{email}"
        end
      end
      emails << "stefano.franzin@mynewsdesk.com"

      exit unless emails.size > 0 && confirm_action?("Requesting GDPR delete for #{emails.join(", ")}. Correct? (y/n)")
      exit unless confirm_action?("This task will be performed on production environments. Correct? (y/n)")

      display.info "Processing GDPR cleanse for #{emails.join(", ")}: "

      # https://github.com/mynewsdesk/mynewsdesk/wiki/gdpr-flows
      display.info "1. Cleaning contacts and Apiary profiles in mnd-production..."

      # TODO: proper task per environment
      # development
      run "cd ../mynewsdesk; bundle exec rake gdpr:remove_all[#{@dry_run},#{emails.join(',')}]"

      # production
      # run "heroku run bundle exec rake gdpr:remove_all[#{@dry_run},#{emails.join(',')}] -a mnd-production"

      display.info "...and done."

      display.info "2. Users in Mixpanel..."

      # production
      [:user, :organization].each do |project|
        auth_token = case project
        when :user
          LocalConfig.instance.mixpanel_user_project_api_secret_token
        when :organization
          LocalConfig.instance.mixpanel_organization_project_api_secret_token
        else
          Mnd.display.error "No Mixpanel credentials found for #{project} Project"
          exit
        end

        display.info "(Project: Prime-#{project})"

        distinct_ids = [] of String

        emails.each do |email_address|

          results = Mnd::Api::Mixpanel.get_user(
            auth_token: auth_token,
            email: email_address,
          )

          begin
            results["results"].as_a.each do |result|
              distinct_ids << "#{result["$distinct_id"]}"
            end
          rescue
            display.warn "something went wrong: #{results.inspect}"
          end
        end

        if @dry_run && distinct_ids.size > 0
          auth_token = case project
          when :user
            LocalConfig.instance.mixpanel_user_project_api_project_token
          when :organization
            LocalConfig.instance.mixpanel_organization_project_api_project_token
          else
            Mnd.display.error "No Mixpanel credentials found for #{project} Project"
            exit
          end

          results = Mnd::Api::Mixpanel.request_deletion(
            auth_token: auth_token,
            user_ids: distinct_ids,
          )

          begin
            display.info "Task id for this removal is: #{results["results"]["task_id"]}"
          rescue
            display.warn "something went wrong: #{results.inspect}"
          end

        end
      end

      display.info "...and done."

      display.info "3. Users in Analyze..."
      # TODO

      display.info "4. Users in Mnd-Audience..."
      # TODO
    end

    private def confirm_action?(question)
      display.info question
      if gets.to_s.[/^y/i]?
        return true
      else
        display.error "Nothing to do."
      end
    end
  end
end
