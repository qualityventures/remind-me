defmodule RemindMe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :remind_me,
      version: "1.0.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {RemindMe.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :elixir_make, :sentry, :parse_trans]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4.6"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.12"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phauxth, "~> 2.1.0"},
      {:argon2_elixir, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:bamboo, "~> 1.1"},
      {:distillery, "~> 2.0"},
      {:httpoison, "~> 1.4"},
      {:sentry, "~> 7.0"},
      {:hackney, "~> 1.14"},
      {:tzdata, "~> 1.0.0"}
    ]
  end
end
