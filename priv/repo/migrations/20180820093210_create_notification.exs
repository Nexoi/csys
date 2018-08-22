defmodule CSys.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :content, :string

      timestamps()
    end
  end
end
