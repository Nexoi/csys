defmodule CSys.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Auth.User

  alias CSys.CourseDao
  alias CSys.Normal.NotificationDao
  alias CSys.Course.LogDao

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    # |> where(role: "student")
    |> order_by(:uid)
    |> Repo.all
  end

  def list_users(page) do
    # Repo.all(User)
    User
    # |> where(role: "student")
    |> order_by(:uid)
    |> Repo.paginate(page)
  end

  def list_users(page, word) do
    word_up = "%#{word |> String.upcase}%"
    query = from c in User,
    # (c.role == "student")
            where: ((like(c.uid, ^word_up)
                      or like(fragment("upper(?)", c.name), ^word_up)
                      or like(fragment("upper(?)", c.class), ^word_up)
                      or like(fragment("upper(?)", c.major), ^word_up))),
            order_by: c.uid
    query
    |> Repo.paginate(page)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def find_user_by_sid!(sid) do
    User
    |> where(uid: ^sid)
    |> Repo.all
    |> List.first
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  CSys.Auth.create_user(%{
    uid: "11610522",
    name: "test",
    class: "test",
    major: "CS",
    password: "yangxiaosu",
    is_active: true,
    role: "admin"
  })
  CSys.Auth.create_user(%{
    uid: "30001085",
    name: "test",
    class: "test",
    major: "CS",
    password: "yangxiaosu",
    is_active: true,
    role: "admin"
  })
    CSys.Auth.create_user(%{
    uid: "30000487",
    name: "test",
    class: "test",
    major: "CS",
    password: "yangxiaosu",
    is_active: true,
    role: "admin"
  })
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}
  CSys.Auth.delete_user(%CSys.Auth.User{
    id: 1
  })
  加入事务管理
  """
  def delete_user(%User{} = user) do
    Repo.transaction fn ->
      # IO.puts "delete course log"
      LogDao.delete_by_user_id(user.id)
      # IO.puts "delete notifications"
      NotificationDao.delete_records_by_user_id(user.id)
      # IO.puts "delete course tables"
      CourseDao.delete_course_tables_by_user_id(user.id)
      # IO.puts "delete user"
      Repo.delete(user)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  验证用户权限，只验证用户密码是否正确
  """
  def authenticate_user(uid, password) do
    query = from(u in User, where: u.uid == ^uid)
    query |> Repo.one() |> verify_password(password)
  end

  defp verify_password(nil, _) do
    # Perform a dummy check to make user enumeration more difficult
    Bcrypt.no_user_verify()
    {:error, "Sorry! You do not have authentication to sign in this site."}
  end

  # 使用本地密码验证，验证不过则使用 CAS 验证（账号必须在本地服务器存在）
  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      verify_password_cas(user, password)
      # {:error, "Wrong password"}
    end
  end

  # CAS 验证
  defp verify_password_cas(user, password) do
      Core.CASConnector.obtain_tgc(user.uid, password)
      |> case do
        {:ok, tgc} ->
          if tgc |> String.contains?("TGC=") do
            {:ok, user}
          else
            {:error, "Wrong Password"}
          end
        {:error} -> {:error, "Wrong Password"}
      end
  end

  ## CSys.Auth.can_enroll_course(1)
  def can_enroll_course(user_id) do
    if user =  User |> where(id: ^user_id) |> Repo.all |> List.first do
      user.status == 1
    else
      false
    end
  end
end
