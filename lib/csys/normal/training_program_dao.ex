defmodule CSys.Normal.TrainingProgramDao do
  @doc """
  培养方案
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Normal.TrainingProgram
  alias CSys.Normal.TrainingProgramItem

  def list_programs do
    programs = TrainingProgram
              |> preload([:training_program_items])
              |> Repo.all
    {:ok, programs}
  end

  def list_programs(program_id) do
    items = TrainingProgramItem
            |> where(traning_program_id: ^program_id)
            |> Repo.all
    {:ok, items}
  end
end
