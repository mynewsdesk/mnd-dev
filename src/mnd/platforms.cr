module Mnd
  PLATFORMS = {
    "prime" => [
      Repo.new("end-to-end-tests", color: :yellow, alias: "end-to-end-tests"),
      Repo.new("mnd-analyze-etl", color: :light_cyan, alias: "audience"),
      Repo.new("mnd-events-api", color: :dark_gray, alias: "events-api"),
      Repo.new("mnd-landing-pages", color: :magenta, alias: "landing-pages"),
      Repo.new("mnd-langdetect", color: :light_yellow, alias: "langdetect"),
      Repo.new("mnd-dev-handbook", color: :light_gray, alias: "dev-handbook"),
      Repo.new("mnd-notifications", color: :light_green, alias: "notifications"),
      Repo.new("mnd-publish-frontend", color: :light_magenta, alias: "publish-frontend"),
      Repo.new("mnd-reader-frontend", color: :white, alias: "reader-frontend"),
      Repo.new("mnd-track-backend", color: :light_red, alias: "track-backend"),
      Repo.new("mnd-ui", color: :light_blue, alias: "ui"),
      Repo.new("mynewsdesk", color: :cyan),
      Repo.new("social-media-monitor", color: :green, alias: "smm"),
    ],

    "poptype" => {
      Repo.new("mndx-analyze", color: :cyan, alias: "analyze"),
      Repo.new("mndx-dashboard", color: :light_blue, alias: "dashboard"),
      Repo.new("mndx-mailer", color: :green, alias: "mailer"),
      Repo.new("mndx-web", color: :red, alias: "web"),
      Repo.new("mndx-amqp", color: :light_red, alias: "amqp"),
      Repo.new("mndx-mailer_client", color: :light_green, alias: "mailer_client"),
    },
  }
end
