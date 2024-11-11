module Mnd
  PLATFORMS = {
    "prime" => [
      Repo.new("mnd-analyze", color: :light_red, alias: "analyze"),
      Repo.new("mnd-audience", color: :light_cyan, alias: "audience"),
      Repo.new("mnd-assets", color: :light_green, alias: "assets"),
      Repo.new("mnd-publish-frontend", color: :yellow, alias: "publish-frontend"),
      Repo.new("mynewsdesk", color: :cyan),
      Repo.new("social-media-monitor", color: :green, alias: "smm"),
    ],
  }
end
