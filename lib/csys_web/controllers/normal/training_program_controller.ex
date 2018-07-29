defmodule CSysWeb.Normal.TrainingProgramController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.TrainingProgramDao
  alias CSysWeb.Normal.TrainingProgramView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/api/normal/training_programs"
    description "列出所有的培养方案（父子目录）"
    # paging
    response 200, "success"
    response 401, "failure"
  end

  def index(conn, _) do
    with {:ok, programs} <- TrainingProgramDao.list_programs do
      # programs |> IO.inspect(label: ">> Normal.TrainingProgramController::index")
      conn
      |> render(TrainingProgramView, "programs.json", programs: programs)
    end
  end


end
