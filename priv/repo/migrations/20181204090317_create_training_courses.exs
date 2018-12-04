defmodule CSys.Repo.Migrations.CreateTrainingCourses do
  use Ecto.Migration

  def change do
    create table(:training_majors) do
      add :name, :string

      timestamps()
    end

  end
end
