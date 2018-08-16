defmodule CSysWeb.Normal.TrainingProgramView do
  use CSysWeb, :view
  # alias CSysWeb.Normal.TrainingProgramView

  # def render("programs.json", %{programs: programs}) do
  #   programs |> IO.inspect(label: ">> Normal.TrainingProgramView::render#programs.json")
  #   %{data: programs}
  # end

  def render("programs.json", %{programs: programs}) do
    programs |> IO.inspect(label: ">> Normal.TrainingProgramView::render#programs.json\n")
    %{data: render_many(programs, CSysWeb.Normal.TrainingProgramView, "program.json")}
    # %{data: programs}
  end

  def render("program.json", %{training_program: program}) do
    program |> IO.inspect(label: ">> Normal.TrainingProgramView::render#program.json\n")
    %{
      id: program.id,
      title: program.title,
      items: render_many(program.training_program_items, CSysWeb.Normal.TrainingProgramView, "item.json"),
      updated_at: program.updated_at,
      inserted_at: program.inserted_at
    }
  end

  def render("item.json", %{training_program: item}) do
    item |> IO.inspect(label: ">> Normal.TrainingProgramView::render#item.json\n")
    %{
      id: item.id,
      title: item.title,
      res_url: item.res_url,
      updated_at: item.updated_at,
      inserted_at: item.inserted_at
    }
  end

end
