defmodule CSys.Repo.Migrations.CreateXiaoli do
  use Ecto.Migration

  def change do
    create table(:xiaolis) do
      add :url, :string
      timestamps()
    end
  end
end
