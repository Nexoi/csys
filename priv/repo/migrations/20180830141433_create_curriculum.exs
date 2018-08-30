defmodule CSys.Repo.Migrations.CreateCurriculum do
  use Ecto.Migration

  def change do
    create table(:curriculum_classes) do
      add :name, :string
      timestamps()
    end
  end
end
