defmodule CSysWeb.Admin.Normal.TrainingProgramItemController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.TrainingProgramDao
  alias CSysWeb.Normal.TrainingProgramView

  action_fallback CSysWeb.FallbackController

  #### program_item ####
  swagger_path :create do
    post "/admin/api/normal/training_program/{program_id}/items"
    description "添加培养方案子项"
    parameters do
      program_id :path, :integer, "father id", required: true
      department :query, :string, "department string", required: true
      title :query, :string, "title string", required: true
      res_url :query, :string, "res_url string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end

  swagger_path :update do
    put "/admin/api/normal/training_program/items/{id}"
    description "修改培养方案子项组合名"
    parameters do
      id :path, :integer, "id integer", required: true
      department :query, :string, "department string", required: true
      title :query, :string, "title string", required: true
      res_url :query, :string, "res_url string", required: true
    end
    response 200, "success"
    response 401, "failure"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/normal/training_program/items/{id}"
    description "修改培养方案子项组合名"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 203, "success"
    response 401, "failure"
  end

  @doc """
  program_item
  """
  def create(conn, %{"program_id" => program_id, "department" => department, "title" => title, "res_url" => url}) do
    {:ok, program_item} =
    %{training_program_id: program_id, department: department, title: title, res_url: url}
    |> TrainingProgramDao.create_program_item
    # |> IO.inspect
    conn
    |> render(CSysWeb.RView, "201.json", data: %{title: program_item.title, res_url: program_item.res_url})
  end

  def update(conn, %{"id" => id, "department" => department, "title" => title, "res_url" => url}) do
    with {:ok, record} <- TrainingProgramDao.get_program_item(id) do
      attr = %{
        id: id,
        department: department,
        title: title,
        res_url: url
      }
      {:ok, program} =
      record
      |> TrainingProgramDao.update_program_item(attr)
      |> IO.inspect
      conn
      |> render(TrainingProgramView, "program_item.json", training_program_item: program)
    end
  end

  def delete(conn, %{"id" => id}) do
    case TrainingProgramDao.get_program_item(id) do
      {:ok, record} ->
        TrainingProgramDao.delete_program_item(record)
        conn
        |> put_status(:non_authoritative_information)
        |> render(CSysWeb.RView, "203.json", record)
      {:error, msg} ->
        conn
        |> send_resp(:not_found, msg)
    end
  end

end
