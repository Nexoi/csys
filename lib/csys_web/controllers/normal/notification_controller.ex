defmodule CSysWeb.Normal.NotoficationController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.Notification
  alias CSysWeb.Normal.NotificationView

  action_fallback CSysWeb.FallbackController

  swagger_path :all do
    get "/api/normal/notifications"
    description "获取全部通知"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :unread do
    get "/api/normal/notifications/unread"
    description "获取全部未读通知"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :read do
    get "/api/normal/notifications/read"
    description "获取全部已读通知"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :show do
    get "/api/normal/notifications/{id}"
    description "获取某条通知（会自动标记为已读状态）"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  def all(conn, _) do
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
