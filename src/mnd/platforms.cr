module Mnd
  PLATFORMS = {
    "prime" => [
      Repo.new("audience-api", color: :yellow),
      Repo.new("mnd-audience", color: :light_cyan, alias: "audience"),
      Repo.new("mnd-events-api", color: :yellow, alias: "events-api"),
      Repo.new("mnd-langdetect", color: :light_yellow, alias: "langdetect"),
      Repo.new("mnd-notifications", color: :light_green, alias: "notifications"),
      Repo.new("mnd-publish-frontend", color: :yellow, alias: "publish-frontend"),
      Repo.new("mnd-publish-tracking", color: :light_blue, alias: "publish-tracking"),
      Repo.new("mnd-reader-frontend", color: :pink, alias: "reader-frontend"),
      Repo.new("mnd-track-backend", color: :light_red, alias: "track-backend"),
      Repo.new("mnd-ui", color: :yellow, alias: "ui"),
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
