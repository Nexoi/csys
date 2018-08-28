defmodule CSys.Normal.TrainingProgramItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias CSys.Normal.TrainingProgram

  schema "training_program_items" do
    field :department, :string, default: ""
    field :title, :string, default: ""
    field :res_url, :string

    belongs_to :training_program, TrainingProgram
    timestamps()
  end

  @doc false
  def changeset(training_program_items, attrs) do
    training_program_items
    |> cast(attrs, [:title, :res_url])
    |> validate_required([:title, :res_url])
  end

end
