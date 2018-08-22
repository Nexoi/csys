defmodule CSys.Repo.Migrations.CreateOpenDate do
  use Ecto.Migration

  def change do
    create table(:open_dates) do
      add :start_time, :integer # 开启选课时间
      add :end_time, :integer   # 关闭选课时间
      add :preview_start_time, :integer
      add :preview_end_time, :integer

      timestamps()
    end
  end
end
