defmodule CSysWeb.Normal.CurriculumController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.CurriculumDao
  alias CSysWeb.Normal.CurriculumView

  action_fallback CSysWeb.FallbackController

  #### program ####
  swagger_path :index do
    get "/api/normal/curriculums"
    description "列出所有的培养方案"
    # paging
    response 200, "success"
    response 401, "failure"
  end

  @doc """
  program
  """
  def index(conn, _) do
    curriculums = CurriculumDao.list_curriculums
    conn
    |> render(CurriculumView, "curriculums.json", %{curriculums: curriculums})
  end

end
