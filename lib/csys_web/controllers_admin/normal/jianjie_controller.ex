defmodule CSysWeb.Admin.Normal.JianjieController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.JianjieDao
  alias CSysWeb.Normal.JianjieView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/normal/jianjie"
    description "获取简介文件的url链接"
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :create do
    post "/admin/api/normal/jianjie"
    description "添加简介文件url"
    parameters do
      url :query, :string, "full url string", required: true
    end
    response 201, "success"
  end

  def index(conn, _) do
    case JianjieDao.get_jianjie do
      {:ok, jianjie} ->
        conn
        |> render(JianjieView, "jianjie.json", jianjie: jianjie)
      {:error, msg} ->
        conn
        |> put_status(:no_content)
        |> render(CSysWeb.RView, "204.json", message: msg)
    end
  end

  def create(conn, params) do
    url = params |> Dict.get("url", nil)
    if url do
      {:ok, jianjie} = JianjieDao.create_jianjie(%{url: url})
      conn
      |> put_status(:created)
      |> render(CSysWeb.RView, "201.json", data: jianjie.url)
    end
  end

end
