defmodule CSysWeb.Normal.XiaoliView do
  use CSysWeb, :view

  def render("xiaoli.json", %{xiaoli: xiaoli}) do
    xiaoli |> IO.inspect(label: ">> Normal.XiaoliView::render#xiaoli.json\n")
    %{
      data: %{url: xiaoli.url }
    }
  end

end
