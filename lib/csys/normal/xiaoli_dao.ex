defmodule CSys.Normal.XiaoliDao do
  @doc """
  校历
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Normal.Xiaoli

  @doc """
  获取最新校历
  """
  def get_xiaoli do
    xiaoli = Xiaoli
              |> order_by(desc: :updated_at)
              |> Repo.all
              |> List.first()
    case xiaoli do
      nil -> {:error, "校历不存在"}
      _ -> {:ok, xiaoli}
    end
  end

  def create_xiaoli(attrs \\ %{}) do
    %Xiaoli{}
    |> Xiaoli.changeset(attrs)
    |> Repo.insert()
  end
end
