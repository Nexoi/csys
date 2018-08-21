defmodule CSys.Courses do
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
    Notification
    |> Repo.all
  end

  def list_notifications_unread(uid) do
    NotificationRecord
    |> where([user_id: ^uid, is_read: ^false])
    |> preload([:notification, :user])
    |> Repo.all
  end

  def list_notifications_isread(uid) do
    NotificationRecord
    |> where([user_id: ^uid, is_read: ^true])
    |> preload([:notification, :user])
    |> Repo.all
  end

  def get_notification(id) do
    case Notification
        |> where(id: ^id)
        |> Repo.all
        |> List.first do
      nil -> {:error, "该通知不存在"}
      notification -> {:ok, notification}
    end
  end

  def get_notification!(id), do: Repo.get!(Notification, id)

  def get_notification_record(user_id, id) do
    case NotificationRecord
        |> where([id: ^id, user_id: ^user_id])
        |> Repo.all
        |> List.first do
      nil -> {:error, "该通知不存在"}
      notification -> {:ok, notification}
    end
  end

  def get_notification_record!(id), do: Repo.get!(NotificationRecord, id)

  def mark_notification_record_read(id) do
    case get_notification_record!(id) do
      nil -> {:error, "No such notification record"}
      record ->
        attr = %{
          is_read: true
        }
        record
        |> update_record(attr)
    end
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

  def update_record(%NotificationRecord{} = record, attrs) do
    record
    |> NotificationRecord.changeset(attrs)
    |> Repo.update()
  end
end
