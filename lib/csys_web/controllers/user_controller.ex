defmodule CSysWeb.UserController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Auth
  alias CSys.Auth.User

  action_fallback CSysWeb.FallbackController

  swagger_path :sign_in do
    post "/api/users/sign_in"
    tag "SIGN IN"
    description "Sign In"
    parameters do
      uid :query, :string, "Student ID", required: true, example: "11610001"
      password :query, :string, "Password", required: true, example: "123456"
    end
    response 200, "success"
    response 401, "failure"
  end

  swagger_path :sign_out do
    post "/api/users/sign_out"
    tag "SIGN IN"
    description "Sign Out"
    response 200, "success"
  end

  swagger_path :show do
    get "/api/users/me"
    tag "SIGN IN"
    description "Sign In"
    response 200, "success"
  end

  swagger_path :update do
    put "/api/users/me"
    description "Edit Me"
    parameters do
      name :query, :string, "name", required: true, example: "xxx"
      class :query, :string, "class", required: true, example: "1601"
      major :query, :string, "major", required: true, example: "CS"
    end
  end

  def sign_in(conn, %{"uid" => uid, "password" => password}) do
    case CSys.Auth.authenticate_user(uid, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)     # 注入会话
        |> put_session(:current_user_role, user.role) # 注入会话
        |> put_status(:ok)
        |> render(CSysWeb.UserView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id) # 如果出现登陆异常，直接删除会话
        |> put_status(:unauthorized)
        |> render(CSysWeb.ErrorView, "401.json", message: message)
    end
  end

  def sign_out(conn, _) do
    current_user_id = get_session(conn, :current_user_id)
    conn
    |> delete_session(:current_user_id) # 删除会话
    |> delete_session(:current_user_role) # 删除会话
    |> render(CSysWeb.RView, "200.json", message: "注销成功")
  end

  def show(conn, _) do
    current_user_id = get_session(conn, :current_user_id)
    user = Auth.get_user!(current_user_id)
    conn
    |> render(CSysWeb.UserView,"show.json", user: user)
  end

  def update(conn, %{"name" => name, "class" => class, "major" => major}) do
    current_user_id = get_session(conn, :current_user_id)
    user = Auth.get_user!(current_user_id)
    user_params = %{
      # id: id,
      # uid: uid,
      name: name,
      class: class,
      major: major
    }
    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, CSysWeb.UserView, "show.json", user: user)
    end
  end

end
