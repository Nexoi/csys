defmodule CSys.Repo.Migrations.AlterIndex do
  use Ecto.Migration

  def change do
    drop unique_index(:training_courses, [:course_code])
    create unique_index(:training_courses, [:major_id, :course_code])
  end
end
