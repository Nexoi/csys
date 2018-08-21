defmodule CSys.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :code, :string # GELS02
      add :name, :string # TOEFL Preparation
      add :class_name, :string # 英文3班
      add :group_name, :string # 全体学生
      add :compus, :string # 一期校区
      add :unit, :string # 语言中心
      add :time, :integer # 32
      add :credit, :float # 0.5
      add :property, :string # 选修
      add :teacher, :string # Joseph Poniatowski
      add :seat_num, :integer # 50
      add :limit_num, :integer # 30
      add :current_num, :integer # 28
      add :notification_cate, :string # 正常
      add :suzhi_cate, :string #
      add :gender_req, :string #
      add :is_stop, :boolean # 是否停课
      add :is_active, :boolean
      add :venue, {:array, :map}, default: []

      timestamps()
    end

    create index(:courses, [:code])
  end
end
