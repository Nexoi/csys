defmodule CSysWeb.CourseImporter do

  alias CSysWeb.CourseProcesser
  alias CSys.CourseDao
  @doc """
  CSysWeb.CourseImporter.import("/Users/neo/Desktop/test2.xlsx")
  CSysWeb.CourseImporter.import("/root/resources/courses_1.xlsx")
  """
  def import(file_name) do
    Excelion.parse!(file_name, 0, 4)
    # |> IO.inspect
    |> Enum.map(fn line ->
      %{
        code: line |> at(0) |> CourseProcesser.to_string(),
        name: line |> at(1) |> CourseProcesser.to_string(),
        class_name: line |> at(2) |> CourseProcesser.to_string(),
        group_name: line |> at(3) |> CourseProcesser.to_string(),
        compus: line |> at(4) |> CourseProcesser.to_string(),
        unit: line |> at(5) |> CourseProcesser.to_string(),
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
        venue: CourseProcesser.convert(line |> at(10), line |> at(11))
      }
      |> CourseDao.create_course()
    end)
    # |> CourseDao.create_courses()
  end

  defp at(list, index) do
    {value, _} = list |> List.pop_at(index)
    value
  end
end
