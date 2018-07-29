defmodule CSysWeb.UserController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Auth
  alias CSys.Auth.User

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    post "/api/users/sign_in"
    description "Sign In"
    parameters do
      uid :query, :string, "Student ID", required: true, example: "11610001"
      password :query, :string, "Password", required: true, example: "123456"
    end
    response 200, "success"
    response 401, "failure"
  end

  def sign_in(conn, %{"uid" => uid, "password" => password}) do
    case CSys.Auth.authenticate_user(uid, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id) # 注入会话
        |> put_status(:ok)
        |> render(CSysWeb.UserView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id) # 如果出现登陆异常，直接删除会话
        |> put_status(:unauthorized)
        |> render(CSysWeb.ErrorView, "401.json", message: message)
    end
  end

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
