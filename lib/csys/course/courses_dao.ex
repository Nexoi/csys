defmodule CSys.CourseDao do
  @doc """
  校历
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Auth
  alias CSys.Course.Term   # 学期
  alias CSys.Course.Course # 课程
  alias CSys.Course.Table  # 学生课表

  @doc """
  查看学期
  """
  def list_terms do
    Term |> Repo.all
  end

  @doc """
  查看可选课的课程信息
  CSys.CourseDao.list_courses(%{page: 0, page_size: 10})
  """
  def list_courses(page) do
    Course |> where(is_active: true) |> Repo.paginate(page)
  end
  def list_courses(page, word) do
    word_s = "%#{word}%"
    query = from c in Course, where: ((c.is_active == true) and (like(c.code, ^word_s) or like(c.name, ^word_s)))
    query
    |> Repo.paginate(page)
  end
  def list_courses_admin(page) do
    Course |> Repo.paginate(page)
  end
  def list_courses_admin(page, word) do
    word_s = "%#{word}%"
    query = from c in Course, where: like(c.code, ^word_s) or like(c.name, ^word_s)
    query
    |> Repo.paginate(page)
  end

  @doc """
  查看学生课表
  CSys.CourseDao.list_course_tables(1, 1)
  """
  def list_course_tables(term_id, user_id) do
    Table
    |> where([user_id: ^user_id, term_id: ^term_id])
    |> preload([:term, :course])
    |> Repo.all
  end
  def list_course_tables_all(term_id, user_id) do
    Table
    |> where([user_id: ^user_id, term_id: ^term_id])
    |> preload([:course])
    |> Repo.all
  end
  def list_course_tables_by_user_id(page, user_id) do
    Table
    |> where(user_id: ^user_id)
    |> Repo.paginate(page)
  end
  def list_course_tables_by_course_id(page, course_id) do
    Table
    |> where(course_id: ^course_id)
    |> Repo.paginate(page)
  end

  #### get ####
  def find_course(course_id) do
    Course |> Repo.get(course_id)
  end

  def find_current_term_id() do
    term = Term |> where(is_default: true) |> order_by(desc: :updated_at) |> Repo.all |> List.first
    if term do
      term.id
    else
      term2 = Term |> order_by(desc: :updated_at) |> Repo.all |> List.first
      if term2 do
        term2.id
      else
        nil
      end
    end
  end

  #### edit ####
  def active_course(course_id) do
    if course = find_course(course_id) do
      attrs = %{
        is_active: true
      }
      course
      |> update_course(attrs)
    end
  end

  def unable_course(course_id) do
    if course = find_course(course_id) do
      attrs = %{
        is_active: false
      }
      course
      |> update_course(attrs)
    end
  end

  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  #### 退选课 ####
  @doc """
  CSys.CourseDao.chose_course(1,1,1)
  CSys.CourseDao.cancel_course(1,1,1)
  """
  def chose_course(user_id, term_id, course_id) do
    course_tables =
    Table
    |> where([user_id: ^user_id, term_id: ^term_id, course_id: ^course_id])
    |> Repo.all
    |> List.first

    if course_tables do
      {:error, "You have selected this course!"}
    else
      if course_rest_plus(course_id) do
        attrs = %{
          user_id: user_id,
          course_id: course_id,
          term_id: term_id
        }
        create_course_table(attrs)
        {:ok, "Select Successfully!"}
      else
        {:error, "None Vacancies left!"}
      end
    end
  end

  def cancel_course(user_id, term_id, course_id) do
    course_tables =
    Table
    |> where([user_id: ^user_id, term_id: ^term_id, course_id: ^course_id])
    |> Repo.all
    |> List.first
    # |> IO.inspect

    if course_tables do
      if course_rest_mins(course_id) do
        # delete
        Table
        |> where([user_id: ^user_id, term_id: ^term_id, course_id: ^course_id])
        |> Repo.delete_all

        {:ok, "Withdraw Successfully!"}
      else
        {:error, "None Vacancies left!"}
      end
    else
      {:error, "You have not selected this course!"}
    end
  end

  def course_rest_plus(course_id) do
    if course = Course |> Repo.get(course_id) do
      if course.current_num <= course.limit_num do
        attrs = %{
          current_num: course.current_num + 1
        }
        course
        |> update_course(attrs)
      end
    end
  end
  def course_rest_mins(course_id) do
    if course = Course |> Repo.get(course_id) do
      # if course.current_num > 0 do
      if true do
        attrs = %{
          current_num: course.current_num - 1
        }
        course
        |> update_course(attrs)
      end
    end
  end

  def create_course_table(attrs \\ %{}) do
    %Table{}
    |> Table.changeset(attrs)
    |> Repo.insert()
  end

  def update_course_table(%Table{} = course, attrs) do
    course
    |> Table.changeset(attrs)
    |> Repo.update()
  end


end
