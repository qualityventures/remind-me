# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :remind_me,
  ecto_repos: [RemindMe.Repo]

# Configures the endpoint
config :remind_me, RemindMeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QqMCQHv+l5yWvwGkis2kJ7GZsSXGuJ+hdj5hkICHEJYSYyRibPNLQfI9F38ygPlp",
  render_errors: [view: RemindMeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RemindMe.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  token_salt: "Num9T9Fb",
  endpoint: RemindMeWeb.Endpoint

# Mailer configuration
config :remind_me, RemindMe.Mailer,
  adapter: Bamboo.LocalAdapter

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
