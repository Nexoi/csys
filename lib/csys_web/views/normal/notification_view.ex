defmodule CSysWeb.Normal.NotificationView do
  use CSysWeb, :view


  def render("notification_records.json", %{notification_records: notifications}) do
    %{data: render_many(notifications, CSysWeb.Normal.NotificationView, "notification_record.json")}
  end

  def render("notifications.json", %{notifications: notifications}) do
    %{data: render_many(notifications, CSysWeb.Normal.NotificationView, "notification.json")}
  end

  def render("notification_record.json", %{notification: notification}) do
    # notification |> IO.inspect(label: ">> Normal.NotificationView::render#notification.json\n")
    %{
      id: notification.id,
      notification_id: notification.notification.id,
      title: notification.notification.title,
      category: notification.notification.category,
      content: notification.notification.content,
      is_read: notification.is_read,
      user_sid: notification.notification.published_user_uid,
      user_role: notification.notification.published_user_role,
      published_at: notification.notification.inserted_at
    }
  end

  def render("notification.json", %{notification: notification}) do
    # notification |> IO.inspect(label: ">> Normal.NotificationView::render#notification.json\n")
    %{
      id: notification.id,
      title: notification.title,
      category: notification.category,
      content: notification.content
    }
  end

end
