module Mnd
  PLATFORMS = {
    "prime" => [
      Repo.new("mynewsdesk", color: :cyan),
      Repo.new("media_monitor", color: :light_red),
      Repo.new("mnd-analyze", color: :light_blue, alias: "analyze"),
      Repo.new("social-media-monitor", color: :green),
      Repo.new("mnd-data", color: :cyan, alias: "data"),
      Repo.new("audience", color: :light_cyan, alias: "data"),
      Repo.new("lang-detector", color: :light_yellow),
      Repo.new("mnd-realtime", color: :cyan, alias: "realtime"),
      Repo.new("apiary"),
      Repo.new("audience-api", color: :yellow),
      Repo.new("mnd-navigation", color: :yellow),
      Repo.new("mnd-ui", color: :yellow),
      Repo.new("mnd-publish-frontend", color: :yellow),
    ],

    "poptype" => {
      Repo.new("mndx-analyze", color: :cyan, alias: "analyze"),
      Repo.new("mndx-dashboard", color: :light_blue, alias: "dashboard"),
      Repo.new("mndx-mailer", color: :green, alias: "mailer"),
      Repo.new("mndx-web", color: :red, alias: "web"),
      Repo.new("mndx-amqp", color: :light_red, alias: "amqp"),
      Repo.new("mndx-mailer_client", color: :light_green, alias: "mailer_client"),
    }
  }
end
