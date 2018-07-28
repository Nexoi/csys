# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :csys,
  namespace: CSys,
  ecto_repos: [CSys.Repo]

# Configures the endpoint
config :csys, CSysWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+vu+1GEzCmNsfz6vnfBv6f1P5FEc78YjNoudfIawsEM0KHTcH1U3OIGroeEP4XDJ",
  render_errors: [view: CSysWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CSys.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
