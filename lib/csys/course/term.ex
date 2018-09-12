defmodule CSys.Course.Term do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Course.Table
  alias CSys.Course.Course

  schema "terms" do
    field :term, :string # default: "2018-2019-1" ?
    field :name, :string
    field :is_default, :boolean, default: false # 是否默认

    has_many :course, Table
    has_many :courses, Course

    timestamps()
  end

  @doc false
  def changeset(terms, attrs) do
    terms
    |> cast(attrs, [:term, :name, :is_default])
    |> validate_required([:term, :name, :is_default])
  end

end
