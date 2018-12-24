defmodule CSys.Repo.Migrations.CreateCourseLog do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :property, :string # 属性，选课/退课等等
      add :detail, :string   # 详情

      timestamps()
    end
  end
end
