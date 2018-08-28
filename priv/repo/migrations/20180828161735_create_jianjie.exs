defmodule CSys.Repo.Migrations.CreateJianjie do
  use Ecto.Migration

  def change do
    create table(:jianjies) do
      add :url, :string
      timestamps()
    end
  end
end
