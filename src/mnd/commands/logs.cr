module Mnd
  class Commands::Logs < Commands::Base
    summary "Check logs"
    usage <<-EOF
      mnd logs # tail all logs
      mnd logs mynewsdesk media_monitor # tail logs from mynewsdesk and media_monitor

      Note: tails log/development.log where available
    EOF

    def perform
      repos = selected_repos.presence || Repo.all
      repos_with_logs = repos.select do |repo|
        File.exists? log_path(repo)
      end

      if repos_with_logs.empty?
        display.warn "No log found in any repo!"
        return
      end

      tail_logs repos_with_logs
    end

    private def tail_logs(repos)
      log_maps = {} of String => Repo
      files = [] of File

      repos.each do |repo|
        path = log_path(repo)
        log_maps[path] = repo
        file = File.open path, "r"
        file.seek 0, IO::Seek::End
        files << file
      end

      display.info "Tailing development logs from #{repos.map(&.short_name).join(", ")}"

      loop do
        lines = files.map do |file|
          repo = log_maps[file.path]
          if line = file.gets
            repo_name_colorized =
              if color = repo.color
                repo.short_name.colorize(color)
              else
                repo.short_name
              end
            "[#{repo_name_colorized}] #{line.strip}"
          end
        end.compact

        if lines.any?
          display.info lines.join("\n")
        else
          sleep 0.2
        end
      end
    end

    private def log_path(repo)
      "#{repo.root}/log/development.log"
    end
  end
end
