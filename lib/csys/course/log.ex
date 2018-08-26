defmodule CSys.Course.Log do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Auth.User

  schema "logs" do
    belongs_to :user, User
    field :property, :string # 属性，选课/退课等等
    field :detail, :string   # 详情

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:user_id, :property, :detail])
    |> validate_required([:user_id, :property, :detail])
  end

end
