defmodule CSys.Training.TrainingCourse do
  use Ecto.Schema
  import Ecto.Changeset

  # mix phx.gen.json Training TrainingCourse training_courses  major_id:integer course_code:string course_name:string course_time:integer course_credit:integer course_property:string
  # mix phx.gen.json Training TrainingMajor training_majors name:string

  alias CSys.Training.TrainingMajor

  schema "training_courses" do
    field :course_code, :string
    field :course_credit, :float
    field :course_name, :string
    field :course_property, :string
    field :course_time, :integer
    belongs_to :major, TrainingMajor

    timestamps()
  end

  @doc false
  def changeset(training_course, attrs) do
    training_course
    |> cast(attrs, [:major_id, :course_code, :course_name, :course_time, :course_credit, :course_property])
    |> validate_required([:major_id, :course_code])
  end
end
