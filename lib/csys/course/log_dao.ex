defmodule CSys.Course.LogDao do
  @moduledoc """
  Logs
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Course.Log


  @doc """
  CSys.Course.LogDao.list(%{page: 1, page_size: 10}, 1)
  CSys.Course.LogDao.list(0, 10, 1)
  """
  def list(page, user_id) do
    Log
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(page)
  end

  def list(timestamp, size, user_id) do
    time = timestamp |> DateTime.from_unix!() |> DateTime.to_naive
    query = from l in Log,
            where: (l.user_id == ^user_id
                    and l.inserted_at > ^time),
            order_by: [desc: l.inserted_at],
            limit: ^size
    query
    |> Repo.all
  end

  @doc """
  CSys.Course.LogDao.log(1, "选课", "课程名：xxx")
  """
  def log(user_id, property, detail) do
    Task.async(fn -> insert(user_id, property, detail) end)
  end

  def insert(user_id, property, detail) do
    %{
      user_id: user_id,
      property: property,
      detail: detail
    } |> create()
  end

  def create(attrs) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert
  end
end
