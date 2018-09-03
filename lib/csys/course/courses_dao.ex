defmodule CSys.CourseDao do
  @doc """
  课程管理
  """
  import Ecto.Query, warn: false
  alias CSys.Repo

  alias CSys.Auth
  alias CSys.Course.Term   # 学期
  alias CSys.Course.Course # 课程
  alias CSys.Course.Table  # 学生课表

  alias CSys.Course.LogDao

  @doc """
  导出
  CSys.CourseDao.export_terms([1, 2, 3])
  """
  def export_terms(term_ids) do
    query = from t in Table,
            where: t.term_id in ^term_ids,
            order_by: [asc: t.user_id, desc: t.term_id]
    query
    |> preload([:user, :term, :course])
    |> Repo.all
  end


  @doc """
  查看学期
  """
  def list_terms do
    Term |> order_by(:id) |> Repo.all
  end

  @doc """
  查看可选课的课程信息
  CSys.CourseDao.list_courses(%{page: 0, page_size: 10})
  """
  def list_courses(page) do
    Course |> where(is_active: true)
           |> order_by(:id)
           |> Repo.paginate(page)
  end
  def list_courses(page, word) do
    word_s = "%#{word}%"
    word_up = "%#{word |> String.upcase}%"
    query = from c in Course,
            where: ((c.is_active == true)
                     and (like(c.code, ^word_up)
                          or like(fragment("upper(?)", c.name), ^word_up)
                          or like(fragment("upper(?)", c.unit), ^word_up)
                          or like(fragment("upper(?)", c.teacher), ^word_up)
                          or like(fragment("upper(?)", c.class_name), ^word_up))),
            # where: ((c.is_active == true)
            #           and (like(c.code, ^word_up)
            #               or like(upcase(c.name), ^word_up)
            #               or like(upcase(c.unit), ^word_up)
            #               or like(upcase(c.class_name), ^word_up))),
            order_by: c.id
    query
    |> Repo.paginate(page)
  end
  def list_courses_admin(page) do
    Course |> order_by(:id)
           |> Repo.paginate(page)
  end
  def list_courses_admin(page, word) do
    word_s = "%#{word}%"
    word_up = "%#{word |> String.upcase}%"
    query = from c in Course,
            # where: like(c.code, ^word_s) or like(c.name, ^word_s),
            where: ((like(c.code, ^word_up)
                          or like(fragment("upper(?)", c.name), ^word_up)
                          or like(fragment("upper(?)", c.unit), ^word_up)
                          or like(fragment("upper(?)", c.teacher), ^word_up)
                          or like(fragment("upper(?)", c.class_name), ^word_up))),
            order_by: c.id
    query
    |> Repo.paginate(page)
  end
  def list_courses_all() do
    Course
    |> Repo.all
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
    # |> IO.inspect
  end
  def list_course_tables_by_user_id(page, user_id) do
    Table
    |> where(user_id: ^user_id)
    |> preload([:course])
    |> Repo.paginate(page)
  end
  def list_course_tables_by_course_id(page, course_id) do
    Table
    |> where(course_id: ^course_id)
    |> preload([:course, :user])
    |> Repo.paginate(page)
  end

  def find_course_table_by_all(user_id, term_id, course_id) do
    Table
    |> where(user_id: ^user_id, term_id: ^term_id, course_id: ^course_id)
    |> Repo.all
    |> List.first
  end

  #### get ####
  def find_course(course_id) do
    Course |> Repo.get(course_id)
  end

  def find_course_by_name!(course_name) do
    Course
    |> where([c], like(c.name, ^course_name))
    |> Repo.all
    |> List.first
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
  def update_course_count(course_id, count) do
    Course
    |> where(id: ^course_id)
    |> Repo.update_all(inc: [current_num: count])
    find_course(course_id)
  end
  @doc """
  CSys.CourseDao.update_course_name("ME484", "New Energy Technologies: Bioenergy Engineering")
  CSys.CourseDao.update_course_name("SS040", "The Anthropology of Kinship and Family")
  """
  def update_course_name(code, name) do
    Course
    |> where(code: ^code)
    |> Repo.update_all(set: [name: name])
  end
  def update_course_rest() do
    Course
    |> Repo.update_all(set: [current_num: 0])
  end

  #### 退选课 ####
  @doc """
  CSys.CourseDao.chose_course(1,1,9640)
  CSys.CourseDao.cancel_course(1,1,9640)
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
      if c = course_rest_plus(course_id) do
        c |> IO.inspect(label: ">> Chose Course")
        attrs = %{
          user_id: user_id,
          course_id: course_id,
          term_id: term_id
        }
        create_course_table(attrs)
        LogDao.log(user_id, "选课", "#{c.id}/[#{c.code}] #{c.name}")
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
      if c = course_rest_mins(course_id) do
        # delete
        Table
        |> where([user_id: ^user_id, term_id: ^term_id, course_id: ^course_id])
        |> Repo.delete_all

        LogDao.log(user_id, "退课", "#{c.id}/[#{c.code}] #{c.name}")
        {:ok, "Withdraw Successfully!"}
      else
        {:error, "None Vacancies left!"}
      end
    else
      {:error, "You have not selected this course!"}
    end
  end

  def inject_course(user_id, term_id, course_id) do
    course_tables =
    Table
    |> where([user_id: ^user_id, term_id: ^term_id, course_id: ^course_id])
    |> Repo.all
    |> List.first

    if course_tables do
      {:error, "You have selected this course!"}
    else
      if course_rest_inject_plus(course_id) do
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

  def course_rest_plus(course_id) do
    if course = Course |> Repo.get(course_id) do
      if course.current_num < course.limit_num do
        # attrs = %{
        #   current_num: course.current_num + 1
        # }
        # course
        # |> update_course(attrs)
        update_course_count(course_id, 1)
      end
    end
  end
  def course_rest_mins(course_id) do
    if course = Course |> Repo.get(course_id) do
      # if course.current_num > 0 do
      if true do
        # attrs = %{
        #   current_num: course.current_num - 1
        # }
        # course
        # |> update_course(attrs)
        update_course_count(course_id, -1)
      end
    end
  end
  def course_rest_inject_plus(course_id) do
    if course = Course |> Repo.get(course_id) do
      # if course.current_num < course.limit_num do
      # attrs = %{
      #   current_num: course.current_num + 1
      # }
      # course
      # |> update_course(attrs)
      update_course_count(course_id, 1)
      # end
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

  #### create course ####
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert
  end
  def create_courses(attrs \\ %{}) do
    %Course{}
    # |> Course.changeset(attrs)
    |> Repo.insert_all(attrs)
  end
  def delete_course(id) do
    Course
    |> where(id: ^id)
    |> Repo.delete_all
  end

  #### term ####
  def set_default_term(term_id) do
    if term = find_term(term_id) do
      # 先把所有的记录都 set 为 false
      Repo.update_all(Term, set: [is_default: false])
      # set
      # Term
      # |> where(id: ^term_id)
      # |> update(set: [is_default: true])
      # |> Repo.update
      term
      |> update_term(%{is_default: true})
    end
  end
  def update_terms_all_undefault() do
    Repo.update_all(Term, set: [is_default: false])
  end

  def find_term(term_id) do
    Repo.get(Term, term_id)
  end
  def create_term(attrs \\ %{}) do
    %Term{}
    |> Term.changeset(attrs)
    |> Repo.insert!
  end
  def update_term(%Term{} = term, attrs) do
    term
    |> Term.changeset(attrs)
    |> Repo.update()
  end
  def delete_term(term_id) do
    Term
    |> where(id: ^term_id)
    |> Repo.delete_all
  end
  @doc """
  CSys.CourseDao.delete_courses
  """
  def delete_courses() do
    Course
    |> Repo.delete_all
  end
end
