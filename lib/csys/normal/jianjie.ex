defmodule CSys.Normal.Jianjie do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  课程简介
  """

  schema "jianjies" do
    field :url, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(jianjie, attrs) do
    jianjie
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end

end
