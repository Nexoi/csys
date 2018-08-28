defmodule CSysWeb.ExportController do
  @moduledoc """
  Export
  """
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.CourseDao
  alias CSysWeb.TableView

  action_fallback CSysWeb.FallbackController

  swagger_path :export_terms do
    get "/admin/api/exports/terms.csv"
    description "导出课程CSV文件（请直接下载，swagger不可用）"
    parameters do
      terms :query, :string, "term_ids, 逗号隔开, 如：1,2,3", required: true
    end
    response 200, "csv file"
  end

  # @file_path "/Users/neo/Desktop"
  @file_path "/root/csys"

  def export_terms(conn, %{"terms" => termstr} = params) do
    terms = termstr |> String.split(",")
                    |> Enum.filter(fn x -> x |> String.length > 0 end)
                    |> Enum.map(fn x -> x |> String.to_integer end)
    if terms do
      tables = CourseDao.export_terms(terms)
      # to csv
      filename = "#{@file_path}/export/#{DateTime.utc_now |> DateTime.to_unix}.csv"
      headers = "学期ID,学期名,学期时间,学号SID,姓名,课程代码,课程名,班级名,组名,老师,授课单位,属性,学时,学分\n"
      content = to_csv_course_tables(tables)
      File.write!(filename, headers <> content)
      conn
      |> put_resp_content_type("application/octet-stream", "utf-8")
      |> send_file(200, filename)
    end
  end

  defp to_csv_course_tables(src_tables) do
    src_tables
    |> Enum.map(fn line ->
      "#{line.term.id}," <>            # id
      "#{line.term.term}," <>          # 学期名
      "#{line.term.name}," <>          # 2018-2019-1
      "#{line.user.uid}," <>           # 学号
      "#{line.user.name |> replace}," <>          # 姓名
      "#{line.course.code}," <>                   # CS101
      "#{line.course.name |> replace}," <>        # 计算机网络
      "#{line.course.class_name |> replace}," <>  # A班
      "#{line.course.group_name |> replace}," <>  # 临班23
      "#{line.course.teacher |> replace}," <>     # 老师
      "#{line.course.unit |> replace}," <>        # 计算机系
      "#{line.course.property |> replace}," <>    # 专业必修
      "#{line.course.time}," <>        # 学时
      "#{line.course.credit}"          # 学分
    end)
    |> Enum.reduce(fn line1, line2 ->
      "#{line1}\n#{line2}"
    end)
  end
  defp replace(nil), do: nil
  defp replace(src) do
    src |> String.replace(",", ";")
  end
end
