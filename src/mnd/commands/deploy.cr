require "../api/buildkite"

module Mnd
  class Commands::Deploy < Commands::Base
    summary "Deploy app to a server"
    usage <<-EOF
    mnd deploy # deploy current branch to a server (chosen interactively)
    mnd deploy <deployment-target> # deploy current branch to the target (eg. mnd-staging)
    EOF

    def perform
      pipeline_slug = get_and_verify_deploy_pipeline_slug_from_path
      branch = Mnd::Utils::Git.current_branch

      Mnd::Utils::Git.verify_remote_branch_up_to_date!(branch)

      display.info "Deploying the '#{branch}' branch..."

      deployment_target = find_or_prompt_for_deployment_target

      display.info ""
      display.info "You're about to deploy the branch '#{branch}' to '#{deployment_target["label"]}'."
      print "Do you want to continue? [y/N] "

      confirmation = gets.to_s

      if confirmation[/^y/i]?
        json = Api::Buildkite.create_build(
          pipeline_slug: pipeline_slug,
          branch: branch,
          deployment_target: deployment_target["value"],
        )

        display.info ""
        display.info "Deploy build created at Buildkite:"
        display.info json["web_url"]
      else
        display.info "Aborted."
        exit
      end
    end

    private def get_and_verify_deploy_pipeline_slug_from_path
      current_dir = `pwd`.chomp.split("/").last
      pipeline_slug = "#{current_dir}-deploy"

      json = Api::Buildkite.get_pipeline(pipeline_slug)

      if json["slug"]?
        json["slug"]
      else
        display.error "Error: It appears your current working directory doesn't correspond with a Buildkite deploy pipeline (looked for '#{pipeline_slug}' but found nothing)"
        exit 1
      end
    end

    private def find_or_prompt_for_deployment_target
      deployment_target_argument = arguments.first?
      available_deployment_targets = read_deployment_targets_from_pipeline_yml

      if deployment_target_argument
        deployment_target = available_deployment_targets.find do |target|
          target["value"] == deployment_target_argument
        end

        return deployment_target if deployment_target

        display.warn "No deployment target matched '#{deployment_target_argument}', refer to the list instead."
      end

      available_deployment_targets.each_with_index do |target, i|
        display.info "#{i + 1}. #{target["label"]}"
      end

      if available_deployment_targets.size == 1
        deployment_target = available_deployment_targets[0]
      else
        print "Where would you like to deploy? [1..#{available_deployment_targets.size}] "

        answer = gets.to_s.to_i
        deployment_target = available_deployment_targets[answer - 1]
      end
    end

    private def read_deployment_targets_from_pipeline_yml
      unless File.exists?(".buildkite/pipeline.yml")
        display.error "Error: couldn't find a .buildkite/pipeline.yml file. Is this repo deployable?"
        exit 1
      end

      pipeline_yaml = File.read(".buildkite/pipeline.yml")
      pipeline = YAML.parse(pipeline_yaml)

      field = deployment_target_field(pipeline)

      if field
        field["options"].as_a
      else
        display.error "Error: couldn't find a deployment-target field in .buildkite/pipeline.yml. Is this repo deployable?"
        exit 1
      end
    end

    private def deployment_target_field(pipeline)
      pipeline["steps"].as_a.each do |step|
        next if step.raw.is_a? String # "wait" step is a plain String

        step = step.as_h
        step.has_key?("fields") && step["fields"].as_a.each do |field|
          return field if field["key"] == "deployment-target"
        end
      end
    end
  end
end
