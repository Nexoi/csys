defmodule CSys.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:course_tables) do
      add :user_id, references(:users, on_delete: :nothing)
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end
  end
end
