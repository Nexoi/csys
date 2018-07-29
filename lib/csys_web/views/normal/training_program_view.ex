defmodule CSysWeb.Normal.TrainingProgramView do
  use CSysWeb, :view
  alias CSysWeb.Normal.TrainingProgramView

  # def render("programs.json", %{programs: programs}) do
  #   programs |> IO.inspect(label: ">> Normal.TrainingProgramView::render#programs.json")
  #   %{data: programs}
  # end

  def render("programs.json", %{programs: programs}) do
    programs |> IO.inspect(label: ">> Normal.TrainingProgramView::render#programs.json")
    %{data: render_many(programs, TrainingProgramView, "program.json")}
  end

  def render("program.json", %{programs: program}) do
    %{
      id: program.id,
      title: program.title,
      items: render_many(program.training_program_items, TrainingProgramView, "item.json"),
      updated_at: program.updated_at,
      inserted_at: program.inserted_at
    }
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      title: item.title,
      res_url: item.res_url,
      updated_at: item.updated_at,
      inserted_at: item.inserted_at
    }
  end

end
