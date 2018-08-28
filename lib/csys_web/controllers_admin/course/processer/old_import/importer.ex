defmodule CSys.Course.OldImporter do
  @moduledoc """
  Importer
  """
  alias CSys.CourseProcesser
  alias CSys.CourseDao
  alias CSys.Auth

  @doc """
  CSys.Course.OldImporter.import("/Users/neo/Desktop/course/old_src.xlsx")
  CSys.Course.OldImporter.import("/Users/neo/Desktop/old_src.xlsx")
  CSys.Course.OldImporter.import("/root/resources/old_src.xlsx")
  """
  def import(file_name) do
    term_id = CourseDao.find_current_term_id()
    Excelion.parse!(file_name, 0, 1)
    |> Enum.map(fn line ->
      sid = line |> at(0)
      course_code = line |> at(1)
      course_name = line |> at(2)
      course = find_course_by_name(course_name, course_code)
      #
      # index = course_name |> index(" /")
      # name = course_name |> String.slice(0, index) |> String.trim
      if course do
        # %{
        #   equals: String.equivalent?(course.name, name),
        #   course_name: course.name,
        #   src_name: course_name
        # } |> IO.inspect
        user = find_user_by_sid(sid)
        %{
          user_id: user.id,
          course_id: course.id,
          term_id: term_id
        }
        |> create_table()
        nil
      else
        course_name
      end
    end)
    |> Enum.filter(fn x -> x end)
  end

  def import(file_name, term_id) do
    Excelion.parse!(file_name, 0, 1)
    |> Enum.map(fn line ->
      sid = line |> at(0)
      course_code = line |> at(1)
      course_name = line |> at(2)
      time = line |> at(3)
      credit = line |> at(4) |> CourseProcesser.to_float()
      teacher = line |> at(5)
      limit_num = line |> at(6) |> String.to_integer

      # course = find_course_by_name(course_name, course_code, credit, teacher, limit_num, time)
      course = find_course_by_name(course_name, course_code)
      user = find_user_by_sid(sid)
      %{
        user_id: user.id,
        course_id: course.id,
        term_id: term_id
      }
      |> create_table()
    end)
  end

  defp at(list, index) do
    {value, _} = list |> List.pop_at(index)
    value
  end

  defp index(src, sub) do
    case String.split(src, sub, parts: 2) do
      [left, _] -> String.length(left)
      [_] -> 1000
    end
  end

  @doc """
  如果找不到就创建一个XX
  (course_name, code, credit, teacher, limit_num, venue)
  CSys.Course.OldImporter.find_course_by_name("", "")
  """
  def find_course_by_name(course_name, code) do
    index = course_name |> index(" /")
    name = course_name |> String.slice(0, index) |> String.trim
    name |> IO.inspect(label: ">>>> name")
    if course = CourseDao.find_course_by_name!("%#{name}%") do
      course
    else
      # {:ok, course_} =
      # %{
      #   code: code,
      #   name: name,
      #   class_name: "#import",
      #   group_name: "#import",
      #   compus: "#import",
      #   unit: "#import",
      #   time: 0,
      #   credit: credit,
      #   property: "#import",
      #   teacher: teacher,
      #   seat_num: limit_num,
      #   limit_num: limit_num,
      #   current_num: 0,
      #   notification_cate: "#import",
      #   suzhi_cate: "#import",
      #   gender_req: "#import",
      #   is_stop: false,
      #   is_active: false,
      #   venue: convert_venue(venue)
      # }
      # |> CourseDao.create_course()
      # course_
    end
  end

  @doc """
  如果找不到就创建一个
  """
  def find_user_by_sid(sid) do
    if user = Auth.find_user_by_sid!(sid) do
      user
    else
      {:ok, user_} =
      %{
        uid: "#{sid}",
        name: "#import_user",
        class: "#import_user",
        major: "#import_user",
        password: "yangxiaosu",
        is_active: true,
        role: "student"
      } |> Auth.create_user()
      user_
    end
  end

  def create_table(attrs) do
    %{
      user_id: user_id,
      course_id: course_id,
      term_id: term_id
    } = attrs
    if table = CourseDao.find_course_table_by_all(user_id, term_id, course_id) do
      {:ok, table}
    else
      attrs |> CourseDao.create_course_table
    end
  end

  #### venue ####
  @doc """
  arg: 3_Mon_10:10-12:00_TB1-502,3_Thur_14:00-15:50_TB1-502
  """
  def convert_venue(venue) do
    venue
    |> String.split(",")
    |> Enum.filter(fn x -> x |> String.length > 0 end)
    |> Enum.map(fn str ->
      list = str |> String.split("_")
      day = list |> at(1)
      time = list |> at(2)
    end)
  end
end
