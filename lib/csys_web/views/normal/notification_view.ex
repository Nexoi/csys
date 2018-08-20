defmodule CSysWeb.Normal.NotificationView do
  use CSysWeb, :view


  def render("notification_records.json", %{notification_records: notifications}) do
    %{data: render_many(notifications, CSysWeb.Normal.NotificationView, "notification_record.json")}
  end

  def render("notifications.json", %{notifications: notifications}) do
    %{data: render_many(notifications, CSysWeb.Normal.NotificationView, "notification.json")}
  end

  def render("notification_record.json", %{notification_record: notification}) do
    notification |> IO.inspect(label: ">> Normal.NotificationView::render#notification.json\n")
    %{
      content: notification.notification_content,
      is_read: notification.is_read
    }
  end

  def render("notification.json", %{notification: notification}) do
    notification |> IO.inspect(label: ">> Normal.NotificationView::render#notification.json\n")
    %{
      content: notification.content
    }
  end

end
