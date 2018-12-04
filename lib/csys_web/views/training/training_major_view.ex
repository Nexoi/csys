defmodule CSysWeb.TrainingMajorView do
  use CSysWeb, :view
  alias CSysWeb.TrainingMajorView

  def render("index.json", %{training_majors: training_majors}) do
    %{data: render_many(training_majors, TrainingMajorView, "training_major.json")}
  end

  def render("show.json", %{training_major: training_major}) do
    %{data: render_one(training_major, TrainingMajorView, "training_major.json")}
  end

  def render("training_major.json", %{training_major: training_major}) do
    %{
      id: training_major.id,
      name: training_major.name,
      updated_at: training_major.updated_at,
      inserted_at: training_major.inserted_at
    }
  end
end
