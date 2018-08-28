defmodule CSysWeb.Normal.NotoficationController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.NotificationDao
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

  swagger_path :isread do
    get "/api/normal/notifications/isread"
    description "获取全部已读通知"
    # paging
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :show do
    get "/api/normal/notifications/read/{id}"
    description "获取某条通知（会自动标记为已读状态）"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 200, "success"
    response 204, "empty"
  end

  def all(conn, _) do
    notifications = NotificationDao.list_notifications
    conn
    |> render(NotificationView, "notifications.json", notifications: notifications)
  end

  def unread(conn, _) do
    current_user_id = get_session(conn, :current_user_id)
    notifications = NotificationDao.list_notifications_unread(current_user_id)
    conn
    |> render(NotificationView, "notification_records.json", notification_records: notifications)
  end

  def isread(conn, _) do
    current_user_id = get_session(conn, :current_user_id)
    notifications = NotificationDao.list_notifications_isread(current_user_id)
    conn
    |> render(NotificationView, "notification_records.json", notification_records: notifications)
  end

  def show(conn, %{"notification_id" => id}) do
    current_user_id = get_session(conn, :current_user_id)
    case NotificationDao.get_notification_record(current_user_id, id) do
      {:ok, notification} ->
        # mark as read
        if not notification.is_read do
          NotificationDao.mark_notification_record_read(notification.id)
        end
        conn
        |> render(NotificationView, "notification_record.json", notification: notification)
      {:error, msg} ->
        conn
        |> put_status(:no_content)
        |> render(CSysWeb.ErrorView, "404.json", message: msg)
    end

  end

end
