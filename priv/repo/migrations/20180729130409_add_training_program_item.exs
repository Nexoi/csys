defmodule CSys.Repo.Migrations.AddTrainingProgramItem do
  use Ecto.Migration

  def change do
    create table(:training_program_items) do
      add :title, :string
      add :res_url, :string
      add :training_program_id, references(:training_programs, on_delete: :delete_all)

      timestamps()
    end
  end
end
