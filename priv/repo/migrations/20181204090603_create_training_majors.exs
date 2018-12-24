defmodule CSys.Repo.Migrations.CreateTrainingMajors do
  use Ecto.Migration

  def change do
    create table(:training_courses) do
      add :course_code, :string
      add :course_name, :string
      add :course_time, :integer
      add :course_credit, :integer
      add :course_property, :string
      add :major_id, references(:training_majors, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:training_courses, [:course_code])
  end
end
