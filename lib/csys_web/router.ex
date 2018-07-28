defmodule CSysWeb.Router do
  use CSysWeb, :router
  alias UserController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CSysWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in
  end
end
