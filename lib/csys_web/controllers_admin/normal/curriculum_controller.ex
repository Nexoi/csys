defmodule CSysWeb.Admin.Normal.CurriculumController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  alias CSys.Normal.CurriculumDao
  alias CSysWeb.Normal.CurriculumView

  action_fallback CSysWeb.FallbackController

  #### program ####
  swagger_path :index do
    get "/admin/api/normal/curriculums"
    description "列出所有的培养方案"
    # paging
    response 200, "success"
    response 401, "failure"
  end

  swagger_path :create do
    post "/admin/api/normal/curriculums"
    description "添加培养方案"
    parameters do
      class_id :query, :string, "integer", required: true
      major_id :query, :string, "integer", required: true
      department_id :query, :string, "integer", required: true
      title :query, :string, "string", required: true
      res_url :query, :string, "string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/admin/api/normal/curriculums/{id}"
    description "删除"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 203, "success"
    response 401, "failure"
  end

  swagger_path :create_class do
    post "/admin/api/normal/curriculums/class"
    parameters do
      name :query, :string, "string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end
  swagger_path :delete_class do
    PhoenixSwagger.Path.delete "/admin/api/normal/curriculums/class/{id}"
    description "删除"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 203, "success"
    response 401, "failure"
  end
  swagger_path :create_major do
    post "/admin/api/normal/curriculums/major"
    parameters do
      name :query, :string, "string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end
  swagger_path :delete_major do
    PhoenixSwagger.Path.delete "/admin/api/normal/curriculums/major/{id}"
    description "删除"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 203, "success"
    response 401, "failure"
  end
  swagger_path :create_department do
    post "/admin/api/normal/curriculums/department"
    parameters do
      name :query, :string, "string", required: true
    end
    response 201, "success"
    response 401, "failure"
  end
  swagger_path :delete_department do
    PhoenixSwagger.Path.delete "/admin/api/normal/curriculums/department/{id}"
    description "删除"
    parameters do
      id :path, :integer, "id integer", required: true
    end
    response 203, "success"
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

  def create(conn, %{"class_id" => class_id, "major_id" => major_id, "department_id" => department_id, "title" => title, "res_url" => res_url}) do
    {:ok, curriculum} =
    %{
      class_id: class_id,
      major_id: major_id,
      department_id: department_id,
      title: title,
      res_url: res_url
    }
    |> CurriculumDao.create
    conn |> success
  end

  def delete(conn, %{"id" => id}) do
    CurriculumDao.delete(id)
    conn |> delete_success
  end

  def create_class(conn, %{"name" => name}) do
    CurriculumDao.create_class(name |> String.trim)
    conn |> success
  end
  def create_major(conn, %{"name" => name}) do
    CurriculumDao.create_major(name |> String.trim)
    conn |> success
  end
  def create_department(conn, %{"name" => name}) do
    CurriculumDao.create_department(name |> String.trim)
    conn |> success
  end

  def delete_class(conn, %{"id" => id}) do
    CurriculumDao.delete_class(id)
    conn |> delete_success
  end
  def delete_major(conn, %{"id" => id}) do
    CurriculumDao.delete_major(id)
    conn |> delete_success
  end
  def delete_department(conn, %{"id" => id}) do
    CurriculumDao.delete_department(id)
    conn |> delete_success
  end


  defp success(conn) do
    conn
    |> put_status(:created)
    |> json(%{message: "Create Successfully!"})
  end

  defp delete_success(conn) do
    conn
    |> put_status(:no_content)
    |> json(%{message: "Delete Successfully!"})
  end
end
