defmodule CSys.Course.Course do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  可选课程列表
  """

  schema "courses" do
    field :code, :string # GELS02
    field :name, :string # TOEFL Preparation
    field :class_name, :string # 英文3班
    field :group_name, :string # 全体学生
    field :compus, :string # 一期校区
    field :unit, :string # 语言中心
    field :time, :integer # 32
    field :credit, :float # 0.5
    field :property, :string # 选修
    field :teacher, :string # Joseph Poniatowski
    field :seat_num, :integer # 50
    field :limit_num, :integer # 30
    field :current_num, :integer # 28
    field :notification_cate, :string # 正常
    field :suzhi_cate, :string #
    field :gender_req, :string #
    field :is_stop, :boolean
    field :is_active, :boolean
    field :venue, {:array, :map}, default: [] # {times:[] locations:[]}

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:is_active, :current_num])
    |> validate_required([:is_active, :current_num])
  end

end
