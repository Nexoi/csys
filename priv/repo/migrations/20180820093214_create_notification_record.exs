defmodule CSys.Repo.Migrations.CreateNotificationRecord do
  use Ecto.Migration

  def change do
    create table(:notification_records) do
      add :is_read, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)
      add :notification_id, references(:notifications, on_delete: :nothing)

      timestamps()
    end
  end
end
