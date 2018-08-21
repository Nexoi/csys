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
    # field :course, Course

    belongs_to :user, User
    belongs_to :term, Term

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

end
