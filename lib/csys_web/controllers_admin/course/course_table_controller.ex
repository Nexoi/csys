defmodule CSysWeb.Admin.CourseTableController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.CourseDao
  alias CSysWeb.TableView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/courses/{course_id}/tables"
    description "获取全部课表"
    paging
    parameters do
      course_id :path, :integer, "课程ID", required: true
    end
    response 200, "success"
  end

  swagger_path :create do
    post "/admin/api/courses/{course_id}/inject/{user_id}"
    description "注入课程"
    parameters do
      course_id :path, :integer, "课程ID", required: true
      user_id :path, :integer, "user_id", required: true
    end
    response 200, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/courses/{course_id}/remove/{user_id}"
    description "移除课程"
    parameters do
      course_id :path, :integer, "课程ID", required: true
      user_id :path, :integer, "user_id", required: true
    end
    response 200, "success"
  end

  def index(conn, params) do
    course_id = params |> Dict.get("course_id", nil)
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer

    page =
    %{
      page: page_number,
      page_size: page_size
    }
    if course_id do
      tables = CourseDao.list_course_tables_by_course_id(page, course_id)
      conn
      |> render(TableView, "table_page_with_user.json", table_page: tables)
    end
  end

  def create(conn, %{"course_id" => course_id, "user_id" => user_id}) do
    current_term_id = CourseDao.find_current_term_id()
    case CourseDao.inject_course(user_id, current_term_id, course_id) do
      {:ok, _} ->
        conn
        |> json(%{message: "Inject Successfully!"})
      {:error, msg} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: msg})
    end
  end

  def delete(conn, %{"course_id" => course_id, "user_id" => user_id}) do
    current_term_id = CourseDao.find_current_term_id()
    case CourseDao.cancel_course(user_id, current_term_id, course_id) do
      {:ok, _} ->
        conn
        |> json(%{message: "Withdraw Successfully!"})
      {:error, msg} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: msg})
    end
  end

end
