defmodule CSys.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.NotificationRecord

  schema "users" do
    field :is_active, :boolean, default: false
    field :uid, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :notifications, NotificationRecord

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :is_active, :password])
    |> validate_required([:uid, :is_active, :password])
    |> unique_constraint(:uid)
    |> put_password_hash()
  end

  defp put_password_hash(
          %Ecto.Changeset{
            valid?: true, changes: %{password: password}
          } = changeset
        ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
