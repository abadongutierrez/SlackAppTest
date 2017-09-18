# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :slack_test_app,
  ecto_repos: [SlackTestApp.Repo]

# Configures the endpoint
config :slack_test_app, SlackTestAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sanki/qfv2ol4d/KCV//DUI9JnJ4cZyRga3hOdikpLxNyGaVuy0PTwKqI8xTIepa",
  render_errors: [view: SlackTestAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackTestApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :oauth2, debug: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
