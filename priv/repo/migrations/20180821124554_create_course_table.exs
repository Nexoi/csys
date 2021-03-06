defmodule CSys.Repo.Migrations.CreateCourseTable do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :is_default, :boolean, default: false
      add :term, :string # default: "2018-2019-1" ?
      add :name, :string
      # add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:terms, [:term])
  end
end
