defmodule CSys.Repo.Migrations.AlterTableCourses do
  use Ecto.Migration

  def change do
    alter table(:course_tables) do
      add :course_code, :string
    end
  end
end
