defmodule CSys.Training.TrainingMajor do
  use Ecto.Schema
  import Ecto.Changeset


  schema "training_majors" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(training_major, attrs) do
    training_major
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
