defmodule CSysWeb.Admin.UserController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Auth
  alias CSys.Auth.User

  alias CSysWeb.UserView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/users"
    description "List All"
    paging
  end

  swagger_path :show do
    get "/admin/api/users/{id}"
    description "List One"
    parameters do
      id :path, :integer, "id, not uid", required: true
    end
  end

  swagger_path :create do
    post "/admin/api/users"
    description "Add User"
    parameters do
      uid :body, :string, "Student ID", required: true, example: "11610001"
    end
  end

  swagger_path :update do
    put "/admin/api/users/{id}"
    description "Edit User"
    parameters do
      id :path, :integer, "id, not uid", required: true
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/users/{id}"
    description "Delete User"
    parameters do
      id :path, :integer, "id, not uid", required: true
    end
  end

  """

  """

  def index(conn, params) do
    page_number = params |> Dict.get("page", 1)
    page_size = params |> Dict.get("page_size", 10)

    users_page =
    %{
      page: page_number,
      page_size: page_size
    }
    |> Auth.list_users()
    # |> IO.inspect(label: ">>>> CSysWeb.Admin.UserController#index\n")
    render(conn, CSysWeb.UserView, "page.json", page: users_page)
  end

  def create(conn, %{"user" => user_params}) do
    # user_params |> IO.inspect(label: ">>>> CSysWeb.Admin.UserController#create\n")
    attr = user_params
    |> Map.put("password", "yangxiaosu")
    |> Map.put("is_active", true)

    with {:ok, %User{} = user} <- Auth.create_user(attr) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render(CSysWeb.UserView,"show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, CSysWeb.UserView, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, CSysWeb.UserView, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
