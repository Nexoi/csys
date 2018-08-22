defmodule CSysWeb.Normal.XiaoliController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.XiaoliDao
  alias CSysWeb.Normal.XiaoliView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/normal/xiaoli"
    description "获取校历文件的url链接"
    # paging
    response 200, "success"
    response 204, "empty"
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


end
