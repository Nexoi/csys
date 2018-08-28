defmodule CSysWeb.Normal.JianjieController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.JianjieDao
  alias CSysWeb.Normal.JianjieView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/normal/jianjie"
    description "获取简介文件的url链接"
    # paging
    response 200, "success"
    response 204, "empty"
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


end
