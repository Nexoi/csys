defmodule CSys.Normal.Curriculum do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.CurriculumClass
  alias CSys.Normal.CurriculumMajor
  alias CSys.Normal.CurriculumDepartment

  schema "curriculums" do
    field :title, :string, default: ""
    field :res_url, :string

    belongs_to :class, CurriculumClass
    belongs_to :major, CurriculumMajor
    belongs_to :department, CurriculumDepartment
    timestamps()
  end

  @doc false
  def changeset(curriculum, attrs) do
    curriculum
    |> cast(attrs, [:class_id, :major_id, :department_id, :title, :res_url])
    |> validate_required([:class_id, :major_id, :department_id, :title, :res_url])
  end

end
