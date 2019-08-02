use Mix.Config

config :remind_me, RemindMeWeb.Endpoint,
  http: [port: 4000],
  url: [host: "remindme.live", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false,
  root: ".",
  version: Application.spec(:remind_me, :vsn)

config :logger,
  backends: [{LoggerFileBackend, :info}, {LoggerFileBackend, :error}]

config :logger, :info,
  path: "/home/Damon/info.log",
  level: :info

config :logger, :error,
  path: "/home/Damon/error.log",
  level: :error

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
