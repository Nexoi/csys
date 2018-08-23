defmodule CSys.CourseTranslanter do

  alias CSys.CourseProcesser
  alias CSys.CourseDao
  alias CSys.CourseTranslanter

  @total_courses_file_name "/Users/neo/Desktop/course/total.xlsx"
  # @total_courses_file_name "/root/resources/total.xlsx"
  @doc """
  CSys.CourseTranslanter.translant("/Users/neo/Desktop/course/zh.xlsx")
  CSys.CourseTranslanter.translant("/root/resources/zh.xlsx")
  """
  def translant(file_name) do
    courses = Excelion.parse!(file_name, 0, 4)

    total_courses =
    Excelion.parse!(@total_courses_file_name, 0, 4)
    |> Enum.map(fn line ->
      # 只需要 code 和 name
      %{
        code: line |> at(0) |> String.trim,
        en_name: line |> at(1) |> String.trim
      }
    end)

    courses
    |> Enum.map(fn line ->
      code = line |> at(0) |> CourseProcesser.to_string()
      %{
        code: code,
        name: line |> at(1) |> en_name(code, total_courses),
        class_name: line |> at(2) |> CourseTranslanter.Dictor.group(),
        group_name: line |> at(3) |> CourseProcesser.to_string(),
        compus: line |> at(4) |> CourseProcesser.to_string(),
        unit: line |> at(5) |> CourseTranslanter.Dictor.unit(),
        time: line |> at(6) |> CourseProcesser.to_integer(),
        credit: line |> at(7) |> CourseProcesser.to_float(),
        property: line |> at(8) |> CourseProcesser.to_string(),
        teacher: line |> at(9) |> CourseProcesser.to_string(),
        seat_num: line |> at(12) |> CourseProcesser.to_integer(),
        limit_num: line |> at(13) |> CourseProcesser.to_integer(),
        current_num: line |> at(14) |> CourseProcesser.to_integer(),
        notification_cate: line |> at(15) |> CourseProcesser.to_string(),
        suzhi_cate: line |> at(16) |> CourseProcesser.to_string(),
        gender_req: line |> at(17) |> CourseProcesser.to_string(),
        is_stop: line |> at(18) |> CourseProcesser.convert_boolean(),
        is_active: line |> at(19) |> CourseProcesser.convert_boolean(),
        venue: CourseProcesser.convert(line |> at(10), line |> at(11) |> CourseTranslanter.Dictor.location())
      }
      |> CourseDao.create_course()
    end)
  end

  defp at(list, index) do
    {value, _} = list |> List.pop_at(index)
    value
  end

  defp en_name(str, code, courses) do
    case courses
        |> Enum.filter(fn x ->
          String.equivalent?(code, x.code)
        end)
        |> List.first do
      nil -> str
      %{code: _, en_name: en_name} -> en_name
    end
  end

  defp t("必修"), do: "ER"
  defp t("选修"), do: "EE"
  defp t("通识必修课"), do: "GER"
  defp t("通识选修课"), do: "GEE"

end
