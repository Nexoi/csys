defmodule CSysWeb.Admin.Course.LogController do
  @moduledoc """
  选课日志
  """
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Course.LogDao
  alias CSysWeb.LogView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/users/{user_id}/courses/logs"
    description "获取全部课程日志"
    paging
    parameters do
      user_id :path, :integer, "用户id", required: true
    end
    response 200, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/users/{user_id}/courses/logs/{log_id}"
    description "删除课程日志"
    parameters do
      user_id :path, :integer, "用户id", required: true
      log_id :path, :integer, "log id", required: true
    end
    response 200, "success"
  end

  def index(conn, %{"user_id" => user_id} = params) do
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer

    page =
    %{
      page: page_number,
      page_size: page_size
    } |> LogDao.list(user_id)
    conn
    |> render(CSysWeb.LogView, "log_page.json", page: page)
  end

  def delete(conn, %{"log_id" => id}) do
    LogDao.delete(id)
    conn
    |> put_status(:no_content)
    |> json(%{message: "Delete Successfully!"})
  end
end
