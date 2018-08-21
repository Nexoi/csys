defmodule CSys.Repo.Migrations.AddUserBasicInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :class, :string
      add :major, :string
      add :role, :string, default: "student"
    end
  end
end
