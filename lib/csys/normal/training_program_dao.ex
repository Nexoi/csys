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

  @doc """
  只能从父 get 内容
  """
  def get_program(program_id) do
    program = TrainingProgram
              |> where(id: ^program_id)
              |> preload([:training_program_items])
              |> Repo.all
              |> List.first
    case program do
      nil -> {:error, "培养方案找不到"}
      _ -> {:ok, program}
    end
  end

  @doc """
  add program, program_item
  """
  def create_program(attrs \\ %{}) do
    %TrainingProgram{}
    |> TrainingProgram.changeset(attrs)
    |> Repo.insert()
  end

  # dont forget program_id
  def create_program_item(attrs \\ %{}) do
    %TrainingProgramItem{}
    |> TrainingProgramItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_program(%TrainingProgram{} = program, attrs) do
    program
    |> TrainingProgram.changeset(attrs)
    |> Repo.update()
  end

  def update_program_item(%TrainingProgramItem{} = program_item, attrs) do
    program_item
    |> TrainingProgramItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_program(%TrainingProgram{} = program) do
    Repo.delete(program)
  end

  def delete_program_item(%TrainingProgramItem{} = program_item) do
    Repo.delete(program_item)
  end
end
