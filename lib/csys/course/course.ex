defmodule CSys.Course.Course do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  可选课程列表
  """
  alias CSys.Course.Term

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

    belongs_to :term, Term

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:term_id, :code, :name, :class_name, :group_name,
      :compus, :unit, :time, :credit, :property, :teacher,
      :seat_num, :limit_num, :current_num, :notification_cate,
      :suzhi_cate, :gender_req, :is_stop, :is_active, :venue
      ])
    |> validate_required([:term_id, :code, :name, :class_name, :group_name,
    :time, :credit, :property,
    :seat_num, :limit_num, :current_num, :is_stop, :is_active
    ])
  end

end
