defmodule CSys.Normal.CurriculumDao do
  @doc """
  培养方案
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Normal.Curriculum
  alias CSys.Normal.CurriculumClass
  alias CSys.Normal.CurriculumMajor
  alias CSys.Normal.CurriculumDepartment

  def list_curriculums do
    Curriculum
    |> preload([:class, :major, :department])
    |> Repo.all
  end
  def create(attrs) do
    %Curriculum{}
    |> Curriculum.changeset(attrs)
    |> Repo.insert()
  end
  def delete(id) do
    Curriculum
    |> where(id: ^id)
    |> Repo.delete_all
  end

  def create_class(name) do
    %CurriculumClass{}
    |> CurriculumClass.changeset(%{name: name})
    |> Repo.insert()
  end
  def create_major(name) do
    %CurriculumMajor{}
    |> CurriculumMajor.changeset(%{name: name})
    |> Repo.insert()
  end
  def create_department(name) do
    %CurriculumDepartment{}
    |> CurriculumDepartment.changeset(%{name: name})
    |> Repo.insert()
  end

  def delete_class(id) do
    CurriculumClass
    |> where(id: ^id)
    |> Repo.delete_all
  end
  def delete_major(id) do
    CurriculumMajor
    |> where(id: ^id)
    |> Repo.delete_all
  end
  def delete_department(id) do
    CurriculumDepartment
    |> where(id: ^id)
    |> Repo.delete_all
  end
end
