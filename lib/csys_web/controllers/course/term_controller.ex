defmodule CSysWeb.Course.TermController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.CourseDao
  alias CSysWeb.TermView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/terms"
    description "获取全部学期"
    response 200, "success"
  end

  def index(conn, params) do
    terms = CourseDao.list_terms
    conn
    |> render(CSysWeb.TermView, "terms.json", terms: terms)
  end

end
