defmodule CSys.Normal.TrainingProgram do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.TrainingProgramItem


  schema "training_programs" do
    field :title, :string, default: ""
    has_many :training_program_items, TrainingProgramItem

    timestamps()
  end

  @doc false
  def changeset(training_programs, attrs) do
    training_programs
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

end
