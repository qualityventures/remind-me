use Mix.Config

# General application configuration
config :remind_me,
  ecto_repos: [RemindMe.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the endpoint
config :remind_me, RemindMeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QqMCQHv+l5yWvwGkis2kJ7GZsSXGuJ+hdj5hkICHEJYSYyRibPNLQfI9F38ygPlp",
  render_errors: [view: RemindMeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RemindMe.PubSub, adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  token_salt: "Num9T9Fb",
  endpoint: RemindMeWeb.Endpoint

# Configures the Sendgrid mailer
config :remind_me, RemindMe.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Sentry error logging
config :sentry,
  dsn: "https://08e4991d3cc84c80a1d4c6ed8dc92088@sentry.io/433417",
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  included_environments: [:prod]

# Sets default timezone database
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
