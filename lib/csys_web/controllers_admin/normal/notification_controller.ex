defmodule CSysWeb.Admin.Normal.NotoficationController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.NotificationDao
  alias CSysWeb.Normal.NotificationView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/normal/notifications"
    description "获取全部通知"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :show do
    get "/admin/api/normal/notifications/{id}"
    description "获取某条通知"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :create do
    post "/admin/api/normal/notifications"
    description "创建通知（会自动发布给所有用户）"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  def all(conn, _) do
    notifications = NotificationDao.list_notifications
    conn
    |> render(NotificationView, "notifications.json", notifications: notifications)
  end

  def show(conn, %{"id" => id}) do
    case NotificationDao.get_notification(id) do
      {:ok, notification} ->
        conn
        |> render(NotificationView, "notification.json", notification: notification)
      {:error, msg} ->
        conn
        |> put_status(:no_content)
        |> render(CSysWeb.ErrorView, "404.json", message: msg)
    end
  end

  def create(conn, %{"content" => content}) do
    %{
      content: content
    }
    |> NotificationDao.create_notification() # 会自动发布给每个用户
  end

end
