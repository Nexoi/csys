defmodule CSysWeb.Admin.Course.OpenDateController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Course.OpenDateDao

  action_fallback CSysWeb.FallbackController

  swagger_path :show do
    get "/admin/api/courses/open_dates"
    description "获取全部时间配置"
    response 200, "success"
  end

  swagger_path :reset do
    post "/admin/api/courses/open_dates"
    description "更新全部时间配置"
    parameters do
      start_time :query, :integer, "", required: false
      end_time :query, :integer, "", required: false
      preview_start_time :query, :integer, "", required: false
      preview_end_time :query, :integer, "", required: false
    end
    response 200, "success"
  end

  def show(conn, _) do
    date = OpenDateDao.get_open_date()
    result = %{
      data: %{
        start_time: date.start_time,
        end_time: date.end_time,
        preview_start_time: date.preview_start_time,
        preview_end_time: date.preview_end_time
      }
    }
    conn
    |> json(result)
  end

  def reset(conn, %{
    "start_time" => _start_time,
    "end_time" => _end_time,
    "preview_start_time" => _preview_start_time,
    "preview_end_time" => _preview_end_time
  } = params) do
    {:ok, _} = OpenDateDao.set_open_date(params)
    conn
    |> json(%{message: "reset successfully!"})
  end

end
