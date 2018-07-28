defmodule CSysWeb.Router do
  use CSysWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CSysWeb do
    pipe_through :api
  end
end
