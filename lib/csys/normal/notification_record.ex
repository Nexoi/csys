defmodule CSys.Normal.NotificationRecord do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Auth.User
  alias CSys.Normal.Notification

  schema "notification_records" do
    belongs_to :user, User
    belongs_to :notification, Notification

    field :is_read, :boolean, default: false, null: false

    timestamps()
  end

  @doc false
  def changeset(notification_record, attrs) do
    notification_record
    |> cast(attrs, [:is_read, :user_id, :notification_id])
    |> validate_required([:is_read, :user_id, :notification_id])
  end

end
