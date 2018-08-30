defmodule CSys.Repo.Migrations.CreateCurriculumClass do
  use Ecto.Migration

  def change do
    create table(:curriculums) do
      add :title, :string
      add :res_url, :string

      add :major_id, references(:curriculum_majors, on_delete: :nothing)
      add :class_id, references(:curriculum_classes, on_delete: :nothing)

      timestamps()
    end
  end
end
