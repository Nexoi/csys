defmodule CSysWeb.Normal.CurriculumView do
  use CSysWeb, :view

  def render("curriculums.json", %{curriculums: curriculums}) do
    %{data: render_many(curriculums, CSysWeb.Normal.CurriculumView, "curriculum.json")}
  end

  def render("curriculum.json", %{curriculum: curriculum}) do
    %{
      id: curriculum.id,
      class_id: curriculum.class.id,
      class_name: curriculum.class.name,
      major_id: curriculum.major.id,
      major_name: curriculum.major.name,
      department_id: curriculum.department.id,
      department_name: curriculum.department.name,
      title: curriculum.title,
      res_url: curriculum.res_url,
      updated_at: curriculum.updated_at,
      inserted_at: curriculum.inserted_at
    }
  end

end
