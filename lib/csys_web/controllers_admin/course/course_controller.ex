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
      term_id :query, :integer, "term_id", required: true
    end
    response 200, "success"
    response 204, "empty"
  end

  swagger_path :show do
    get "/admin/api/courses/{id}"
    description "获取课程"
    parameters do
      id :path, :integer, "course_id", required: true
    end
    response 200, "success"
  end

  swagger_path :create do
    post "/admin/api/courses"
    parameters do
      term_id :query, :integer, "number", required: true
      code :query, :string, "GELS02", required: true
      name :query, :string, "TOEFL Preparation", required: true
      class_name :query, :string, "英文3班", required: true
      group_name :query, :string, "全体学生", required: true
      compus :query, :string, "default: 一期校区", required: false
      unit :query, :string, "语言中心", required: true
      time :query, :integer, "32", required: true
      credit :query, :float, "0.5", required: true
      property :query, :string, "选修", required: true
      teacher :query, :string, "Joseph Poniatowski", required: true
      seat_num :query, :integer, "50", required: true
      limit_num :query, :integer, "30", required: true
      current_num :query, :integer, "28", required: false
      notification_cate :query, :string, "正常", required: false
      suzhi_cate :query, :string, "（素质类别）", required: false
      gender_req :query, :string, "（性别要求）", required: false
      is_stop :query, :boolean, "default false", required: false
      is_active :query, :boolean, "default true", required: false
      venue :query, :string, "json array", required: true
    end
    response 201, "success"
  end

  swagger_path :update do
    put "/admin/api/courses/{id}"
    parameters do
      term_id :query, :integer, "number", required: true
      id :path, :integer, "9999", required: true
      code :query, :string, "GELS02", required: false
      name :query, :string, "TOEFL Preparation", required: false
      class_name :query, :string, "英文3班", required: false
      group_name :query, :string, "全体学生", required: false
      compus :query, :string, "一期校区", required: false
      unit :query, :string, "语言中心", required: false
      time :query, :integer, "32", required: false
      credit :query, :float, "0.5", required: false
      property :query, :string, "选修", required: false
      teacher :query, :string, "Joseph Poniatowski", required: false
      seat_num :query, :integer, "50", required: false
      limit_num :query, :integer, "30", required: false
      current_num :query, :integer, "28", required: false
      notification_cate :query, :string, "正常", required: false
      suzhi_cate :query, :string, "（素质类别）", required: false
      gender_req :query, :string, "（性别要求）", required: false
      is_stop :query, :boolean, "true", required: false
      is_active :query, :boolean, "false", required: false
      venue :query, :string, "json array", required: false
    end
    response 201, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/courses/{id}"
    description "删除课程"
    parameters do
      id :path, :integer, "course_id", required: true
    end
    response 204, "success"
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
    word = params |> Map.get("word", nil)
    page_number = params |> Map.get("page", "1") |> String.to_integer
    page_size = params |> Map.get("page_size", "10") |> String.to_integer
    term_id_str = params |> Map.get("term_id", nil)
    term_id = if term_id_str do
      term_id_str |> String.to_integer
    else
      CourseDao.find_current_term_id()
    end
    page =
    %{
      page: page_number,
      page_size: page_size
    }
    courses = if word do
      CourseDao.list_courses_admin_by_term(page, term_id, word)
    else
      CourseDao.list_courses_admin_by_term(page, term_id)
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

  #### course create/update/get/delete
  def create(conn, %{
      "term_id" => term_id,
      "code" => code,
      "name" => name,
      "class_name" => class_name,
      "group_name" => group_name,
      "unit" => unit,
      "time" => time,
      "credit" => credit,
      "property" => property,
      "teacher" => teacher,
      "seat_num" => seat_num,
      "limit_num" => limit_num,
      "venue" => venue_str
    } = params) do
    is_stop = params |> Map.get("is_stop", false)
    is_active = params |> Map.get("is_active", true)
    compus = params |> Map.get("compus", "一期校区")
    current_num = params |> Map.get("current_num", "0") |> String.to_integer
    notification_cate = params |> Map.get("notification_cate")
    suzhi_cate = params |> Map.get("suzhi_cate")
    gender_req = params |> Map.get("gender_req")
    params |> IO.inspect(label: ">>>> Course params")
    try do
      venue = venue_str |> encode_venue()
      case %{
        term_id: term_id,
        code: code,
        name: name,
        class_name: class_name,
        group_name: group_name,
        venue: venue,
        unit: unit,
        time: time,
        credit: credit,
        property: property,
        teacher: teacher,
        seat_num: seat_num,
        limit_num: limit_num,
        is_active: is_active,
        compus: compus,
        current_num: current_num,
        notification_cate: notification_cate,
        suzhi_cate: suzhi_cate,
        gender_req: gender_req,
        is_stop: is_stop
      } |> CourseDao.create_course() do
        {:ok, _} -> conn |> put_status(:created) |> json(%{message: "Create Successfully!"})
        {:error, msg} -> conn |> put_status(:bad_request) |> json(%{message: msg})
      end
    rescue
      Poison.SyntaxError ->
        conn |> put_status(:bad_request) |> json(%{message: "Venue format error!"})
      Poison.EncodeError ->
        conn |> put_status(:bad_request) |> json(%{message: "Parameters format error!"})
    end
  end

  def update(conn, %{"id" => id} = params) do
    if c = CourseDao.find_course(id) do
      try do
        venue = params |> Map.get("venue")
        p = if venue do
          params |> Map.delete("id") |> Map.replace!("venue", venue |> encode_venue())
        else
          params |> Map.delete("id")
        end
        case c |> CourseDao.update_course(p) do
          {:ok, _} -> conn |> put_status(:created) |> json(%{message: "Update Successfully!"})
          {:error, msg} -> conn |> put_status(:bad_request) |> json(%{message: msg})
        end
      rescue
        Poison.SyntaxError ->
          conn |> put_status(:bad_request) |> json(%{message: "Venue format error!"})
        Poison.EncodeError ->
          conn |> put_status(:bad_request) |> json(%{message: "Parameters format error!"})
      end
    else
      conn |> put_status(:not_found) |> json(%{message: "No such course info"})
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    CourseDao.delete_course(id)
    conn |> put_status(:no_content) |> json(%{message: "Delete Successfully!"})
  end

  def show(conn, %{"id" => id} = _params) do
    if course = CourseDao.find_course(id) do
      conn |> render(CourseView, "course.json", course: course)
    else
      conn |> put_status(:not_found) |> json(%{message: "No such course"})
    end
  end

  defp to_float(nil), do: nil
  defp to_float(""), do: 0.0
  defp to_float(str) do
    if String.contains?(".") do
      str |> String.to_float
    else
      str |> String.to_integer
    end
  end

  defp encode_venue(venue) do
    venue |> Poison.decode!
  end
end
