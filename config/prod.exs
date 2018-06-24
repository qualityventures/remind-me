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

config :sentry,
  dsn: "https://08e4991d3cc84c80a1d4c6ed8dc92088@sentry.io/433417",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
