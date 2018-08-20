defmodule CSys.Normal.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.NotificationRecord

  schema "notifications" do
    field :content, :string, default: ""

    has_many :notifications, NotificationRecord

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

end
