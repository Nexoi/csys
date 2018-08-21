defmodule CSysWeb.Router do
  use CSysWeb, :router
  # alias UserController
  # alias CSysWeb.Normal.TrainingProgramController
  alias PhoenixSwagger.Plug.Validate

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    # plug Validate, validation_failed_status: 422
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  pipeline :api_auth_admin do
    plug :ensure_authenticated_admin
  end

  scope "/api/users", CSysWeb do
    pipe_through :api
    post "/sign_in", UserController, :sign_in
  end

  # 直接放行的 API
  scope "/api", CSysWeb do
    pipe_through [:api, :api_auth]
    post "/users/sign_in", UserController, :sign_out
    get "/users/me", UserController, :show
    get "/normal/training_programs", Normal.TrainingProgramController, :index
    get "/normal/xiaoli", Normal.XiaoliController, :index
    get "/normal/notifications", Normal.NotoficationController, only: [:all, :show]
    get "/normal/notifications/unread", Normal.NotoficationController, :unread
    get "/normal/notifications/isread", Normal.NotoficationController, :isread
  end

  # 需要权限验证的 API
  scope "/admin/api", CSysWeb do
    pipe_through [:api, :api_auth_admin]
    # pipe_through :api
    resources "/users", Admin.UserController, only: [:index, :show, :create, :update, :delete]
    resources "/normal/training_programs", Admin.Normal.TrainingProgramController, only: [:index, :show, :create, :update, :delete]
    resources "/normal/training_program/items", Admin.Normal.TrainingProgramItemController, only: [:create, :update, :delete]
    resources "/normal/xiaoli", Admin.Normal.XiaoliController, only: [:index, :create]
    resources "/normal/notifications", Normal.NotoficationController, only: [:index, :show, :create]
  end

  # 权限验证，普通用户
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    current_user_role = get_session(conn, :current_user_role)

    if current_user_id do
      conn
    else
      conn |> refuse_render
    end
  end

  # 权限验证，管理员
  defp ensure_authenticated_admin(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    current_user_role = get_session(conn, :current_user_role)

    conn |> refuse_render
    if current_user_id do
      if current_user_role do
        if String.equivalent?(current_user_role, "admin") do
          conn
        end
      end
    end
  end

  defp refuse_render(conn) do
    conn
    |> put_status(:unauthorized)
    |> render(CSysWeb.ErrorView, "401.json", message: "Unauthenticated user")
    |> halt()
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
        host: "jwxt.sustc.seeuio.com"
      }
    }
  end
end
