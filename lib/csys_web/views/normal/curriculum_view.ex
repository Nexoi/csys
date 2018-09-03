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

  ## name: xxx, only father item for curriculums
  def render("curriculum_classes.json", %{curriculum_classes: curriculums}) do
    %{data: render_many(curriculums, CSysWeb.Normal.CurriculumView, "curriculum_class.json")}
  end
  def render("curriculum_majors.json", %{curriculum_majors: curriculums}) do
    %{data: render_many(curriculums, CSysWeb.Normal.CurriculumView, "curriculum_major.json")}
  end
  def render("curriculum_departments.json", %{curriculum_departments: curriculums}) do
    %{data: render_many(curriculums, CSysWeb.Normal.CurriculumView, "curriculum_department.json")}
  end
  def render("curriculum_class.json", %{curriculum: class}), do: %{id: class.id, name: class.name}
  def render("curriculum_major.json", %{curriculum: major}), do: %{id: major.id, name: major.name}
  def render("curriculum_department.json", %{curriculum: department}), do: %{id: department.id, name: department.name}

end
