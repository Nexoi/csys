defmodule CSysWeb.Admin.Course.TermController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.CourseDao
  alias CSysWeb.TermView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/terms"
    description "获取全部学期"
    response 200, "success"
  end

  swagger_path :default do
    put "/admin/api/terms/{term_id}"
    description "设置当前学期"
    parameters do
      term_id :path, :integer, "", required: true
    end
    response 200, "success"
  end

  swagger_path :create do
    post "/admin/api/terms"
    parameters do
      term :query, :string, "2018-2019-1", required: true
      name :query, :string, "Spring Semester X", required: true
    end
    response 201, "success"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/terms/{term_id}"
    parameters do
      term_id :path, :integer, "", required: true
    end
    response 200, "success"
  end

  def index(conn, params) do
    terms = CourseDao.list_terms
    conn
    |> render(CSysWeb.TermView, "terms.json", terms: terms)
  end

  def create(conn, %{"term" => term, "name" => name}) do
    attrs = %{
      term: term,
      name: name,
      is_default: false
    }
    if CourseDao.create_term(attrs) do
      conn
      |> put_status(:created)
      |> json(%{message: "Create Successfully!"})
    end
  end

  def delete(conn, %{"id" => term_id}) do
    CourseDao.delete_term(term_id)
    send_resp(conn, :non_authoritative_information, "")
  end

  def default(conn, %{"term_id" => term_id}) do
    if CourseDao.set_default_term(term_id) do
      conn
      |> json(%{message: "Set Successfully!"})
    else
      conn
      |> put_status(:bad_request)
      |> json(%{message: "Set Fail, Unknow Exception"})
    end
  end
end
