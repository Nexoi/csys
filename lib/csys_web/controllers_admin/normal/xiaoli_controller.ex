defmodule CSysWeb.Admin.Normal.XiaoliController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.XiaoliDao
  alias CSysWeb.Normal.XiaoliView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/normal/xiaoli"
    description "获取校历文件的url链接"
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :create do
    post "/admin/api/normal/xiaoli"
    description "添加校历文件url"
    parameters do
      url :query, :string, "full url string", required: true
    end
    response 201, "success"
  end

  def index(conn, _) do
    case XiaoliDao.get_xiaoli do
      {:ok, xiaoli} ->
        conn
        |> render(XiaoliView, "xiaoli.json", xiaoli: xiaoli)
      {:error, msg} ->
        conn
        |> put_status(:no_content)
        |> render(CSysWeb.RView, "204.json", message: msg)
    end
  end

  def create(conn, params) do
    url = params |> Dict.get("url", nil)
    if url do
      {:ok, xiaoli} = XiaoliDao.create_xiaoli(%{url: url})
      conn
      |> put_status(:created)
      |> render(CSysWeb.RView, "201.json", data: xiaoli.url)
    end
  end

end
