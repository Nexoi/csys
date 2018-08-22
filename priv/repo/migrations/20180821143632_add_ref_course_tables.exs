defmodule CSys.Repo.Migrations.AddRefCourseTables do
  use Ecto.Migration

  def change do
    alter table(:course_tables) do
      add :term_id, references(:terms, on_delete: :nothing)
    end
  end
end
