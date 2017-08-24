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
    ],

    "poptype" => {
      Repo.new("mndx-web"),
    }
  }
end
