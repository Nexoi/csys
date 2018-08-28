defmodule CSys.Normal.JianjieDao do
  @doc """
  校历
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Normal.Jianjie

  @doc """
  获取最新校历
  """
  def get_jianjie do
    jianjie = Jianjie
              |> order_by(desc: :updated_at)
              |> Repo.all
              |> List.first()
    case jianjie do
      nil -> {:error, "校历不存在"}
      _ -> {:ok, jianjie}
    end
  end

  def create_jianjie(attrs \\ %{}) do
    %Jianjie{}
    |> Jianjie.changeset(attrs)
    |> Repo.insert()
  end
end
