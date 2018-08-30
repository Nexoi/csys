defmodule CSys.Repo.Migrations.CreateCurriculumMajor do
  use Ecto.Migration

  def change do
    create table(:curriculum_majors) do
      add :name, :string
      timestamps()
    end
  end
end
