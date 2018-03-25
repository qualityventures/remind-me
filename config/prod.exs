use Mix.Config

config :remind_me, RemindMeWeb.Endpoint,
  http: [port: 80],
  url: [host: "www.remindme.live"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:remind_me, :vsn)

  # Do not print debug messages in production
config :logger, level: :info

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
