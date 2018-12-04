defmodule CSys.Course.Table do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  学生自己的课表
  """

  alias CSys.Auth.User

  alias CSys.Course.Term
  alias CSys.Course.Course

  schema "course_tables" do
    # field :course_id, :integer

    belongs_to :course, Course
    belongs_to :user, User
    belongs_to :term, Term

    timestamps()
  end

  @doc false
  def changeset(course_table, attrs) do
    course_table
    |> cast(attrs, [:user_id, :term_id, :course_id])
    |> validate_required([:user_id, :course_id])
  end

end
