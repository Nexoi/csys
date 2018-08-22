defmodule CSys.Course.OpenDate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "open_dates" do
    field :start_time, :integer # 开启选课时间
    field :end_time, :integer   # 关闭选课时间
    field :preview_start_time, :integer
    field :preview_end_time, :integer

    timestamps()
  end

  @doc false
  def changeset(open_date, attrs) do
    open_date
    |> cast(attrs, [:start_time, :end_time, :preview_start_time, :preview_end_time])
    |> validate_required([:start_time, :end_time, :preview_start_time, :preview_end_time])
  end

end
