use Mix.Config

config :remind_me, RemindMeWeb.Endpoint,
  http: [port: 4000],
  url: [host: "remindme.live", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false,
  root: ".",
  version: Application.spec(:remind_me, :vsn)

# Do not print debug messages in production
config :logger, level: :info

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
