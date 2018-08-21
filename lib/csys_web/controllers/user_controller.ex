defmodule CSysWeb.UserController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  # alias CSys.Auth
  # alias CSys.Auth.User

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



end
