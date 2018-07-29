defmodule CSys.Repo.Migrations.AddTrainingProgram do
  use Ecto.Migration

  def change do
    create table(:training_programs) do
      add :title, :string

      timestamps()
    end

  end
end
