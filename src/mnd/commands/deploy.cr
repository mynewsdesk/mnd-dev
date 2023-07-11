require "../api/github"

module Mnd
  class Commands::Deploy < Commands::Base
    summary "Deploy app to a server"
    usage <<-EOF
    Recommended usage of mnd deploy assumes that your working directory is the repo to be deployed:
    mnd deploy # deploy current branch to a server (chosen interactively)
    mnd deploy <deployment-target> # deploy current branch to the target (eg. mnd-staging)

    If you don't have local access to the github repo you may deploy like this instead:
    mnd deploy <repo> <branch> <deployment-target>
    EOF

    def perform
      # The triple argument version is meant to be used without local access to the git repo,
      # originally conceived for QA consultants not employed at mynewsdesk. It is more brittle
      # than normal usage since we're unable to validate input to the same extent.
      if arguments.size == 3
        repository, branch, deployment_target_argument = arguments

        deployment_target = deployment_target_argument
      else
        repository = Dir.current.split("/").last

        branch = Mnd::Utils::Git.current_branch
        Mnd::Utils::Git.verify_remote_branch_up_to_date!(branch)

        deployment_target_argument = arguments[0] if arguments.size == 1

        deployment_target = find_or_prompt_for_deployment_target(deployment_target_argument)
      end

      display.info "Deploying the '#{branch}' branch..."

      display.info ""
      display.info "You're about to deploy the branch '#{branch}' to '#{deployment_target}'."
      print "Do you want to continue? [y/N] "

      confirmation = gets.to_s

      if confirmation[/^y/i]?
        Api::Github.workflow_dispatch!(
          owner: "mynewsdesk",
          repository: repository,
          workflow_id: "deploy.yml",
          ref: branch,
          inputs: { "deployment_target" => deployment_target },
        )

        display.info ""
        display.info "Deploy workflow triggered at Github."
        display.info "Navigate to https://github.com/mynewsdesk/#{repository}/actions to find the job and see the progress."
      else
        display.info "Aborted."
        exit
      end
    end

    private def deploy_pipeline_slug_from_path
      current_dir = `pwd`.chomp.split("/").last
      "#{current_dir}-deploy"
    end

    private def find_or_prompt_for_deployment_target(deployment_target_argument : String?)
      available_deployment_targets = read_deployment_targets_from_github_deploy_yml

      if deployment_target_argument
        deployment_target = available_deployment_targets.find do |target|
          target == deployment_target_argument
        end

        return deployment_target if deployment_target

        display.warn "No deployment target matched '#{deployment_target_argument}', refer to the list instead."
      end

      available_deployment_targets.each_with_index do |target, i|
        display.info "#{i + 1}. #{target}"
      end

      if available_deployment_targets.size == 1
        deployment_target = available_deployment_targets[0]
      else
        print "Where would you like to deploy? [1..#{available_deployment_targets.size}] "

        answer = gets.to_s.to_i
        deployment_target = available_deployment_targets[answer - 1]
      end
    end

    private def read_deployment_targets_from_github_deploy_yml
      unless File.exists?(".github/workflows/deploy.yml")
        display.error "Error: couldn't find a .github/workflows/deploy.yml file. Is this repo deployable?"
        exit 1
      end

      deploy_yaml = File.read(".github/workflows/deploy.yml")
      workflow = YAML.parse(deploy_yaml)

      deployment_target_node = deployment_target_node(workflow)

      if deployment_target_node
        deployment_target_node["options"].as_a
      else
        display.error "Error: couldn't find a on.workflow_dispatch.inputs.deployment_target field in .github/workflows/deploy. Is this repo deployable?"
        exit 1
      end
    end

    private def deployment_target_node(workflow)
      return unless on = workflow[true]? || workflow["on"]?

      on.dig?("workflow_dispatch", "inputs", "deployment_target")
    end
  end
end
