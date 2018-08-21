defmodule CSysWeb.Admin.CourseController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.CourseDao
  alias CSysWeb.CourseView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/courses"
    description "获取全部课程"
    paging
    parameters do
      word :query, :string, "搜索关键词，可选", required: false
    end
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :active do
    post "/admin/api/courses/{course_id}/active"
    description "激活课程"
    parameters do
      course_id :path, :integer, "课程ID", required: true
    end
    response 200, "success"
  end

  swagger_path :unable do
    PhoenixSwagger.Path.delete "/admin/api/courses/{course_id}/unable"
    description "激活课程"
    parameters do
      course_id :path, :integer, "课程ID", required: true
    end
    response 200, "success"
  end

  def index(conn, params) do
    word = params |> Dict.get("word", nil)
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer

    page =
    %{
      page: page_number,
      page_size: page_size
    }
    courses = if word do
      CourseDao.list_courses_admin(page, word)
    else
      CourseDao.list_courses_admin(page)
    end
    conn
    |> render(CourseView, "courses_page.json", courses_page: courses)
  end

  def active(conn, %{"course_id" => course_id}) do
    if CourseDao.active_course(course_id) do
      conn
      |> json(%{message: "Active Successfully!"})
    else
      conn
      |> put_status(:bad_request)
      |> json(%{message: "Active fail, Please try again."})
    end
  end

  def unable(conn, %{"course_id" => course_id}) do
    if CourseDao.unable_course(course_id) do
      conn
      |> json(%{message: "Disable Successfully!"})
    else
      conn
      |> put_status(:bad_request)
      |> json(%{message: "Disable fail, Please try again."})
    end
  end

end
