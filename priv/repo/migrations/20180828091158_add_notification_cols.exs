defmodule CSys.Repo.Migrations.AddNotificationCols do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :title, :string
      add :category, :string
      add :published_user_uid, :string
      add :published_user_role, :string
      # add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
