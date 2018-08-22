defmodule CSys.Course.OpenDateDao do
  @doc """
  开放日期
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Course.OpenDate

  def get_open_date() do
    case OpenDate
        |> Repo.all
        |> List.first do
      nil ->
        {:ok, record} =
        %{
          start_time: 0,
          end_time: 0,
          preview_start_time: 0,
          preview_end_time: 0
        } |> create()
        record
      open_date ->
        open_date
    end
  end

  def set_open_date(params) do
    get_open_date()
    |> update_open_date(params)
  end

  def create(attrs \\ %{}) do
    %OpenDate{}
    |> OpenDate.changeset(attrs)
    |> Repo.insert()
  end

  def update_open_date(%OpenDate{} = open_date, attrs) do
    open_date
    |> OpenDate.changeset(attrs)
    |> Repo.update()
  end

end
