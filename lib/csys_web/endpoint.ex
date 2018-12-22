defmodule CSysWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :csys

  socket "/socket", CSysWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    # at: "/files", from: "/Users/neo/Desktop/csys",
    at: "/files", from: "/root/csys",
    at: "/", from: :csys, gzip: false
    # only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    length: 1_000_000_000

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "yangxiaosu",
    signing_salt: "lovesusu"

  # 自定义的 CORS 配置
  plug Corsica,
    origins: [
      "http://oop.project.seeuio.com",
      "http://oop.project.seeuio.com:81",
      "http://oop.project.seeuio.com:8000",
      "http://oop.project.seeuio.com:8080",
      "http://localhost:4002",
      "http://localhost:8000",
      "http://tis.sustc.edu.cn",
      "http://tis.sustc.edu.cn:8000",
      "http://localhost:4000",
      "http://172.18.8.156:8000",
      "http://oop.sustc.seeuio.com",
      "http://oop.sustc.seeuio.com:4003",
      "http://jwxt.sustc.seeuio.com",
      "http://jwxt.sustc.seeuio.com:4002"],
    log: [rejected: :error, invalid: :warn, accepted: :debug],
    allow_headers: ["content-type"],
    allow_credentials: true

  plug CSysWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("SUSTC_JWXT_PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
