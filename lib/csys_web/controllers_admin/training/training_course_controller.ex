defmodule CSysWeb.AdminTrainingCourseController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Training
  alias CSys.Training.TrainingCourse
  alias CSysWeb.TrainingCourseView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/training/majors/{major_id}/courses"
    description "获取全部专业课程"
    parameters do
      major_id :path, :integer, "major_id", required: true
    end
    paging
    response 200, "success"
  end

  swagger_path :show do
    get "/admin/api/training/majors/{major_id}/courses/{course_id}"
    description "获取某一专业课程"
    parameters do
      major_id :path, :integer, "major_id", required: true
      course_id :path, :integer, "course_id", required: true
    end
    response 200, "success"
  end

  swagger_path :create do
    post "/admin/api/training/majors/{major_id}/courses"
    parameters do
      major_id :path, :integer, "专业ID", required: true
      course_code :query, :string, "CS101", required: true
      course_credit :query, :float, "3.0", required: true
      course_name :query, :string, "计算机科学与技术", required: true
      course_property :query, :string, "MR", required: true
      course_time :query, :integer, "60", required: true
    end
    response 201, "success"
  end

  swagger_path :update do
    put "/admin/api/training/majors/{major_id}/courses/{course_id}"
    parameters do
      major_id :path, :integer, "major_id", required: true
      course_id :path, :integer, "course_id", required: true
      course_code :query, :string, "CS101", required: true
      course_credit :query, :float, "3.0", required: true
      course_name :query, :string, "计算机科学与技术", required: true
      course_property :query, :string, "MR", required: true
      course_time :query, :integer, "60", required: true
    end
    response 201, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/training/majors/{major_id}/courses/{course_id}"
    description "删除专业课程"
    parameters do
      course_id :path, :integer, "course_id", required: true
    end
    response 204, "success"
  end

  def index(conn, %{"major_id" => major_id} = params) do
    page_number = params |> Dict.get("page", "1") |> String.to_integer
    page_size = params |> Dict.get("page_size", "10") |> String.to_integer
    page =
    %{
      page: page_number,
      page_size: page_size
    }
    training_courses = Training.page_training_courses(major_id, page)
    render(conn, TrainingCourseView, "index.json", training_courses: training_courses)
  end

  def create(conn, params) do
    with {:ok, %TrainingCourse{} = training_course} <- Training.create_training_course(params) do
      conn
      |> put_status(:created)
      |> json(%{message: "create success"})
      # |> render(TrainingCourseView, "show.json", training_course: training_course)
    end
  end

  def show(conn, %{"id" => id}) do
    training_course = Training.get_training_course!(id)
    render(conn, TrainingCourseView, "show.json", training_course: training_course)
  end

  def update(conn, %{"id" => id} = params) do
    training_course = Training.get_training_course!(id)

    with {:ok, %TrainingCourse{} = training_course} <- Training.update_training_course(training_course, params) do
      render(conn, TrainingCourseView, "show.json", training_course: training_course)
    end
  end

  def delete(conn, %{"id" => id}) do
    training_course = Training.get_training_course!(id)
    with {:ok, %TrainingCourse{}} <- Training.delete_training_course(training_course) do
      send_resp(conn, :no_content, "")
    end
  end
end
