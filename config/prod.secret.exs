use Mix.Config

config :remind_me, RemindMeWeb.Endpoint,
  secret_key_base: "zj30Yvqd+Gx36shKx4LcovFZstrLs2Fv5WGRopmHsk76mw3Umm+MnTnD44Zw85tm"

# Configure your database
config :remind_me, RemindMe.Repo,
  hostname: "localhost",
  username: "postgres",
  password: "W2P3wmzN2a~U^:gr",
  database: "remind_me",
  ssl: true,
  pool_size: 10

# Configures the Sendgrid mailer
config :remind_me, RemindMe.Emails.Mailer,
api_key: "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"
