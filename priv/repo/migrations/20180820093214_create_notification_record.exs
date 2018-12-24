defmodule CSys.Repo.Migrations.CreateNotificationRecord do
  use Ecto.Migration

  def change do
    create table(:notification_records) do
      add :is_read, :boolean, default: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :notification_id, references(:notifications, on_delete: :delete_all)

      timestamps()
    end
  end
end
