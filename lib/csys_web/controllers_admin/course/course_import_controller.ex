defmodule CSysWeb.Admin.Course.ImportController do
  use CSysWeb, :controller
  use PhoenixSwagger # 注入 Swagger

  action_fallback CSysWeb.FallbackController


  swagger_path :import do
    post "/admin/api/courses/import"
    description "导入课程 xlsx"
    parameters do
      file :body, :file, "file", required: true
      term_id :query, :integer, "term_id", required: true
    end
    response 201, "success"
  end

  
  def import(conn, %{"term_id" => term_id} = params) do
    # IO.inspect params
    if upload = params["file"] do
      try do
        temp_path = "/seeu/csys_store/temp_courses#{DateTime.utc_now |> DateTime.to_unix}.xlsx"
        File.cp(upload.path, temp_path)
        CSys.CourseTranslanter.translant(term_id, temp_path, "/root/resources/total.xlsx")
        conn
        |> put_status(:created)
        |> json(%{message: "success"})
      rescue
        err ->
          IO.inspect err
          conn
          |> put_status(:bad_request)
          |> json(%{message: "上传课程格式异常！【文件格式必须为 .xlsx，且必须配表格标题、表头信息，正文需在第4行开始】"})
      end
    else
      conn
      |> put_status(:bad_request)
      |> json(%{
        messgae: "upload fail"
      })
    end
  end
end
