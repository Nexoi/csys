use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :csys, CSysWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :csys, CSys.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("USERNAME") || "neo",
  password: System.get_env("PASSWORD") || "",
  database: "csys_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4
