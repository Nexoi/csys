defmodule CSys.Training do
  @moduledoc """
  The Training context.
  """

  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Training.TrainingCourse


  def page_training_courses(major_id, page) do
    TrainingCourse
    |> where([major_id: ^major_id])
    |> preload([:major])
    |> Repo.paginate(page)
  end

  # 会增加已经选读过的课程
  def page_my_training_courses(user_id, major_id, page) do
    TrainingCourse
    |> where([major_id: ^major_id])
    |> preload([:major])
    |> Repo.paginate(page)
  end

  @doc """
  Returns the list of training_courses.

  ## Examples

      iex> list_training_courses()
      [%TrainingCourse{}, ...]

  """
  def list_training_courses do
    TrainingCourse
    |> preload([:major])
    |> Repo.all
  end

  @doc """
  Gets a single training_course.

  Raises `Ecto.NoResultsError` if the Training course does not exist.

  ## Examples

      iex> get_training_course!(123)
      %TrainingCourse{}

      iex> get_training_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_training_course!(id), do: Repo.get!(TrainingCourse, id)

  @doc """
  Creates a training_course.

  ## Examples

      iex> create_training_course(%{field: value})
      {:ok, %TrainingCourse{}}

      iex> create_training_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_training_course(attrs \\ %{}) do
    %TrainingCourse{}
    |> TrainingCourse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a training_course.

  ## Examples

      iex> update_training_course(training_course, %{field: new_value})
      {:ok, %TrainingCourse{}}

      iex> update_training_course(training_course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_training_course(%TrainingCourse{} = training_course, attrs) do
    training_course
    |> TrainingCourse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TrainingCourse.

  ## Examples

      iex> delete_training_course(training_course)
      {:ok, %TrainingCourse{}}

      iex> delete_training_course(training_course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_training_course(%TrainingCourse{} = training_course) do
    Repo.delete(training_course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking training_course changes.

  ## Examples

      iex> change_training_course(training_course)
      %Ecto.Changeset{source: %TrainingCourse{}}

  """
  def change_training_course(%TrainingCourse{} = training_course) do
    TrainingCourse.changeset(training_course, %{})
  end

  alias CSys.Training.TrainingMajor

  @doc """
  Returns the list of training_majors.

  ## Examples

      iex> list_training_majors()
      [%TrainingMajor{}, ...]

  """
  def list_training_majors do
    Repo.all(TrainingMajor)
  end

  @doc """
  Gets a single training_major.

  Raises `Ecto.NoResultsError` if the Training major does not exist.

  ## Examples

      iex> get_training_major!(123)
      %TrainingMajor{}

      iex> get_training_major!(456)
      ** (Ecto.NoResultsError)

  """
  def get_training_major!(id), do: Repo.get!(TrainingMajor, id)

  @doc """
  Creates a training_major.

  ## Examples

      iex> create_training_major(%{field: value})
      {:ok, %TrainingMajor{}}

      iex> create_training_major(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_training_major(attrs \\ %{}) do
    %TrainingMajor{}
    |> TrainingMajor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a training_major.

  ## Examples

      iex> update_training_major(training_major, %{field: new_value})
      {:ok, %TrainingMajor{}}

      iex> update_training_major(training_major, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_training_major(%TrainingMajor{} = training_major, attrs) do
    training_major
    |> TrainingMajor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TrainingMajor.

  ## Examples

      iex> delete_training_major(training_major)
      {:ok, %TrainingMajor{}}

      iex> delete_training_major(training_major)
      {:error, %Ecto.Changeset{}}

  """
  def delete_training_major(%TrainingMajor{} = training_major) do
    Repo.delete(training_major)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking training_major changes.

  ## Examples

      iex> change_training_major(training_major)
      %Ecto.Changeset{source: %TrainingMajor{}}

  """
  def change_training_major(%TrainingMajor{} = training_major) do
    TrainingMajor.changeset(training_major, %{})
  end
end
