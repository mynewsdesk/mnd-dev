module Mnd
  PLATFORMS = {
    "prime" => [
      Repo.new("mynewsdesk", color: :cyan),
      Repo.new("social-media-monitor", color: :green),
      Repo.new("mnd-data", color: :cyan, alias: "data"),
      Repo.new("audience", color: :light_cyan, alias: "data"),
      Repo.new("lang-detector", color: :light_yellow),
      Repo.new("apiary"),
      Repo.new("audience-api", color: :yellow),
      Repo.new("mnd-content-marketplace-backend", color: :yellow, alias: "content-marketplace-backend"),
      Repo.new("mnd-navigation", color: :yellow, alias: "navigation"),
      Repo.new("mnd-ui", color: :yellow, alias: "ui"),
      Repo.new("mnd-publish-frontend", color: :yellow, alias: "publish-frontend"),
      Repo.new("mnd-events-api", color: :yellow, alias: "events-api"),
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
