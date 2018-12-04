defmodule CSys.Repo.Migrations.AlterTrainingCourses do
  use Ecto.Migration

  def change do
    alter table(:training_courses) do
      remove :course_credit
      add :course_credit, :float
    end
  end
end
