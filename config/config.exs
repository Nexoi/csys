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
  url: [host: System.get_env("SUSTC_JWXT_HOSTNAME"), port: System.get_env("SUSTC_JWXT_PORT") || 4002],
  secret_key_base: "whatever_i_do_is_all_for_susu_lalalalalalalalalalalalalalalalala",
  render_errors: [view: CSysWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CSys.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Swagger
config :csys, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: CSysWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: CSysWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# config :csys, :phoenix_swagger,
#   swagger_files: %{
#     # "booking-api.json" => [router: CSys.BookingRouter],
#     # "reports-api.json" => [router: CSys.ReportsRouter],
#     "priv/static/student-api.json" => [router: CSysWeb.Router]
#   }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
