defmodule CSys.Repo.Migrations.AddUserStatus do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :status, :integer, default: 1
    end
  end
end
