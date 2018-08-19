defmodule CSysWeb.Router do
  use CSysWeb, :router
  # alias UserController
  # alias CSysWeb.Normal.TrainingProgramController

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  # 直接放行的 API
  scope "/api", CSysWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
    get "/normal/training_programs", Normal.TrainingProgramController, :index
    get "/normal/xiaoli", Normal.XiaoliController, :index
  end

  # 需要权限验证的 API
  scope "/admin/api", CSysWeb do
    # pipe_through [:api, :api_auth]
    pipe_through :api
    resources "/users", Admin.UserController, only: [:index, :show, :create, :update, :delete]
    resources "/normal/xiaoli", Admin.Normal.XiaoliController, only: [:index, :create]
  end

  # 权限验证，验证失败就 401
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(CSysWeb.ErrorView, "401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :csys, swagger_file: "swagger.json"
  end

  # swagger info
  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Jwxt-En",
        host: "mix.red"
      }
    }
  end
end
