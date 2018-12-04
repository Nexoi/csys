defmodule CSysWeb.TrainingCourseController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Training
  alias CSys.Training.TrainingCourse

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/training/majors/{major_id}/courses"
    description "获取全部专业课程"
    parameters do
      major_id :path, :integer, "major_id", required: true
    end
    paging
    response 200, "success"
  end

  swagger_path :show do
    get "/api/training/majors/{major_id}/courses/{course_id}"
    description "获取某一专业下的某一课程"
    parameters do
      major_id :path, :integer, "major_id", required: true
      course_id :path, :integer, "course_id", required: true
    end
    response 200, "success"
  end

  def index(conn, %{"major_id" => major_id} = params) do
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer
    page =
    %{
      page: page_number,
      page_size: page_size
    }
    current_user_id = get_session(conn, :current_user_id)

    training_courses = Training.page_my_training_courses(current_user_id, major_id, page)
    render(conn, "index_with_status.json", training_courses: training_courses)
  end

  def show(conn, %{"id" => id}) do
    training_course = Training.get_training_course!(id)
    render(conn, "show.json", training_course: training_course)
  end
end
