defmodule CSysWeb.Router do
  use CSysWeb, :router
  # alias UserController
  # alias CSysWeb.Normal.TrainingProgramController
  alias PhoenixSwagger.Plug.Validate

  alias CSys.Course.OpenDateDao

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    # plug Validate, validation_failed_status: 422
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  pipeline :api_auth_admin do
    plug :ensure_authenticated_admin
  end

  pipeline :api_auth_course_preview do
    plug :is_preview_day
  end

  pipeline :api_auth_course_open do
    plug :is_open_day
  end

  # 不需要任何权限验证
  scope "/api/users", CSysWeb do
    pipe_through :api
    post "/sign_in", UserController, :sign_in
    post "/upload", FileController, :upload
  end

  # 直接放行的 API（普通用户可使用）
  scope "/api", CSysWeb do
    pipe_through [:api, :api_auth]
    post "/users/sign_out", UserController, :sign_out
    get "/users/me", UserController, :show
    get "/normal/training_programs", Normal.TrainingProgramController, :index
    get "/normal/xiaoli", Normal.XiaoliController, :index
    get "/normal/jianjie", Normal.JianjieController, :index
    get "/normal/notifications", Normal.NotoficationController, :all
    get "/normal/notifications/read/:notification_id", Normal.NotoficationController, :show
    get "/normal/notifications/unread", Normal.NotoficationController, :unread
    get "/normal/notifications/isread", Normal.NotoficationController, :isread
    get "/tables/current", CourseController, :current_table
    get "/tables/history/:term_id", CourseController, :table
    get "/terms", Course.TermController, :index
  end

  # 需要特定时刻开放的 API
  scope "/api/courses", CSysWeb do
    pipe_through [:api, :api_auth, :api_auth_course_preview]
    get "", CourseController, :index
    post "/courses/:course_id", CourseController, :chose
    delete "/courses/:course_id", CourseController, :cancel
  end
  scope "/api/courses/", CSysWeb do
    pipe_through [:api, :api_auth, :api_auth_course_open]
    get "", CourseController, :index
    post ":course_id", CourseController, :chose
    delete ":course_id", CourseController, :cancel
  end

  # 需要权限验证的 API
  scope "/admin/api", CSysWeb do
    pipe_through [:api, :api_auth_admin]
    post "/upload", FileController, :upload
    get "/exports/terms.csv", ExportController, :export_terms
    # pipe_through :api
    resources "/users", Admin.UserController, only: [:index, :show, :create, :update, :delete]
    resources "/normal/training_programs", Admin.Normal.TrainingProgramController, only: [:index, :show, :create, :update, :delete]
    resources "/normal/training_program/items", Admin.Normal.TrainingProgramItemController, only: [:update, :delete]
    post "/normal/training_program/:program_id/items", Admin.Normal.TrainingProgramItemController, :create
    resources "/normal/xiaoli", Admin.Normal.XiaoliController, only: [:index, :create]
    resources "/normal/jianjie", Admin.Normal.JianjieController, only: [:index, :create]
    resources "/normal/notifications", Admin.Normal.NotoficationController, only: [:index, :show, :create]
    get "/courses", Admin.CourseController, :index
    post "/courses/:course_id/active", Admin.CourseController, :active
    delete "/courses/:course_id/unable", Admin.CourseController, :unable
    get "/courses/open_dates", Admin.Course.OpenDateController, :show
    post "/courses/open_dates", Admin.Course.OpenDateController, :reset
    get "/courses/:course_id/tables", Admin.CourseTableController, :index
    get "/users/:user_id/tables", Admin.CourseTableController, :user_tables
    get "/users/:user_id/terms/:term_id/tables", Admin.CourseTableController, :user_term_tables
    post "/courses/:course_id/inject/:user_id", Admin.CourseTableController, :create
    delete "/courses/:course_id/remove/:user_id", Admin.CourseTableController, :delete
    resources "/terms", Admin.Course.TermController, only: [:index, :create, :delete]
    put "/terms/:term_id", Admin.Course.TermController, :default
  end

  # 权限验证，普通用户
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    current_user_role = get_session(conn, :current_user_role)

    if current_user_id do
      conn
    else
      conn |> refuse_render
    end
  end

  # 权限验证，管理员
  defp ensure_authenticated_admin(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    # |> IO.inspect(label: ">> current_user_id")
    current_user_role = get_session(conn, :current_user_role)
    # |> IO.inspect(label: ">> current_user_role")

    if current_user_id != nil
      and current_user_role != nil
      and String.equivalent?(current_user_role, "admin") do
        # IO.inspect(label: ">> current_admin")
        conn
    else
      conn |> refuse_render
    end
  end

  # 验证是否是开放选课状态
  defp is_open_day(conn, _opts) do
    date = OpenDateDao.get_open_date
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    if date.start_time < timestamp
    and date.end_time > timestamp do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{message: "Forbidden! Not Available Time"})
    end
  end

  # 验证是否是开放预览选课状态
  defp is_preview_day(conn, _opts) do
    date = OpenDateDao.get_open_date
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    if date.preview_start_time < timestamp
    and date.preview_end_time > timestamp do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{message: "Forbidden! Not Available Time"})
    end
  end

  defp refuse_render(conn) do
    conn
    |> put_status(:unauthorized)
    |> render(CSysWeb.ErrorView, "401.json", message: "Unauthenticated user")
    |> halt()
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :csys, swagger_file: "swagger.json"
  end

  # swagger info
  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Jwxt-En",
        host: "jwxt.sustc.seeuio.com"
      }
    }
  end
end
