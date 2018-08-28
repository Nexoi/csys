defmodule CSys.Repo.Migrations.AddTrainingItemDepartment do
  use Ecto.Migration

  def change do
    alter table(:training_program_items) do
      add :department, :string, default: ""
    end
  end
end
