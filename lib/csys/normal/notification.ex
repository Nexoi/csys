defmodule CSys.Normal.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.NotificationRecord
  alias CSys.Auth.User

  schema "notifications" do
    field :content, :string, default: ""
    field :title, :string
    field :category, :string
    field :published_user_uid, :string
    field :published_user_role, :string
    # belongs_to :user, User

    has_many :notifications, NotificationRecord

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:title, :category, :content, :published_user_uid, :published_user_role])
    |> validate_required([:title, :category, :content])
  end

end
