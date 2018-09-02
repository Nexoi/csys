defmodule CSysWeb.Course.LogController do
  @moduledoc """
  选课日志
  """
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Course.LogDao
  alias CSysWeb.LogView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/courses/logs"
    description "获取全部课程日志"
    paging
    response 200, "success"
  end

  def index(conn, params) do
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer
    current_user_id = get_session(conn, :current_user_id)

    page =
    %{
      page: page_number,
      page_size: page_size
    } |> LogDao.list(current_user_id)
    conn
    |> render(CSysWeb.LogView, "log_page.json", page: page)
  end

end
