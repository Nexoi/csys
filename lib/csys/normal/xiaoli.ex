defmodule CSys.Normal.Xiaoli do
  use Ecto.Schema
  import Ecto.Changeset

  schema "xiaolis" do
    field :url, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(xiaoli, attrs) do
    xiaoli
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

end
