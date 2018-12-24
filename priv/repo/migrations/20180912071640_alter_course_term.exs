defmodule CSys.Repo.Migrations.AlterCourseTerm do
  use Ecto.Migration

  def change do
    alter table(:courses) do
      add :term_id, references(:terms, on_delete: :delete_all)
    end
  end
end
