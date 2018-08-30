defmodule CSys.Repo.Migrations.CreateCurriculumDepartment do
  use Ecto.Migration

  def change do
    create table(:curriculum_departments) do
      add :name, :string

      timestamps()
    end
  end
end
