defmodule CSys.Normal.CurriculumDepartment do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.Curriculum


  schema "curriculum_departments" do
    field :name, :string, default: ""
    has_many :curriculums, Curriculum

    timestamps()
  end

  @doc false
  def changeset(curriculum_department, attrs) do
    curriculum_department
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

end
