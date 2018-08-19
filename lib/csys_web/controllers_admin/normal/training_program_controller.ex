defmodule CSysWeb.Admin.Normal.TrainingProgramController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.TrainingProgramDao
  alias CSysWeb.Normal.TrainingProgramView

  action_fallback CSysWeb.FallbackController

  swagger_path :index do
    get "/admin/api/normal/training_programs"
    description "列出所有的培养方案（父子目录）"
    # paging
    response 200, "success"
    response 401, "failure"
  end

  swagger_path :create do
    post "/admin/api/normal/training_programs"
    description "添加培养方案组合名"
    parameters do
      title :query, :string, "title string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end

  swagger_path :update do
    put "/admin/api/normal/training_programs/{id}"
    description "修改培养方案组合名"
    parameters do
      id :path, :integer, "id integer", required: true
      title :query, :string, "title string", required: true
    end
    response 200, "success"
    response 401, "failure"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/normal/training_programs/{id}"
    description "修改培养方案组合名"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 204, "success"
    response 401, "failure"
  end

  def index(conn, _) do
    with {:ok, programs} <- TrainingProgramDao.list_programs do
      # programs |> IO.inspect(label: ">> Normal.TrainingProgramController::index")
      conn
      |> render(TrainingProgramView, "programs.json", programs: programs)
      # |> json(programs)
    end
  end

  @doc """
  program
  """
  def create(conn, %{"title" => title}) do
    {:ok, program} =
    %{title: title}
    |> TrainingProgramDao.create_program
    |> IO.inspect
    conn
    |> render(CSysWeb.RView, "201.json", data: %{title: program.title})
  end

  def update(conn, %{"id" => id, "title" => title}) do
    with {:ok, program_record} <- TrainingProgramDao.get_program(id) do
      attr = %{
        id: id,
        title: title
      }
      {:ok, program} =
      program_record
      |> TrainingProgramDao.update_program(attr)
      |> IO.inspect
      conn
      |> render(TrainingProgramView, "program.json", training_program: program)
    end
  end

  def delete(conn, %{"id" => id}) do
    case TrainingProgramDao.get_program(id) do
      {:ok, program_record} ->
        TrainingProgramDao.delete_program(program_record)
        conn
        |> render(CSysWeb.RView, "203.json", program_record)
      {:error, msg} ->
        conn
        |> send_resp(:not_found, msg)
        # conn
        # |> render(CSysWeb.ErrorView, "404.json", message: msg)
    end
  end
end
