defmodule CSys.Normal.CurriculumClass do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.Curriculum


  schema "curriculum_classes" do
    field :name, :string, default: ""
    has_many :curriculums, Curriculum

    timestamps()
  end

  @doc false
  def changeset(curriculum_class, attrs) do
    curriculum_class
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

end
