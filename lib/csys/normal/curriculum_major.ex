defmodule CSys.Normal.CurriculumMajor do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.Curriculum


  schema "curriculum_majors" do
    field :name, :string, default: ""
    has_many :curriculums, Curriculum

    timestamps()
  end

  @doc false
  def changeset(curriculum_major, attrs) do
    curriculum_major
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

end
