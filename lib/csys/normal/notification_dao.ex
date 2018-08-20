defmodule CSys.Normal.NotificationDao do
  @doc """
  校历
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Auth
  alias CSys.Normal.Notification
  alias CSys.Normal.NotificationRecord

  @doc """
  notification
  """
  def list_notifications do
    notifications = Notification
                    |> Repo.all
    {:ok, notifications}
  end

  def create_notification(attrs \\ %{}) do
    {:ok, notification} =
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
    # insert record to every user
    dispatch_records(notification.id)
  end

  def dispatch_records(notification_id) do
    # get user ids
    record_attrs =
    Auth.list_users
    |> Enum.map(fn user ->
      %{
        user_id: user.id,
        notification_id: notification_id
      }
    end)
    # start insert
    NotificationRecord
    |> Repo.insert_all(record_attrs)
  end

  def delete_notifications(notification_id) do
    Notification
    |> where(id: ^notification_id)
    |> Repo.delete_all
    # 应该会自动删除关联的 record
  end

  defp delete_records(notification_id) do
    NotificationRecord
    |> where(notification_id: ^notification_id)
    |> Repo.delete_all
  end
end
