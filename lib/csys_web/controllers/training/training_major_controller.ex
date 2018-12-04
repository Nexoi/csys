defmodule CSysWeb.TrainingMajorController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Training
  alias CSys.Training.TrainingMajor

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/training/majors"
    description "获取全部专业"
    response 200, "success"
  end

  swagger_path :show do
    get "/admin/api/training/majors/{major_id}"
    description "获取某一专业"
    parameters do
      id :path, :integer, "major_id", required: true
    end
    response 200, "success"
  end
  
  def index(conn, _params) do
    training_majors = Training.list_training_majors()
    render(conn, "index.json", training_majors: training_majors)
  end

  def show(conn, %{"id" => id}) do
    training_major = Training.get_training_major!(id)
    render(conn, "show.json", training_major: training_major)
  end

end
