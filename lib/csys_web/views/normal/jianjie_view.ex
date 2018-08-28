defmodule CSysWeb.Normal.JianjieView do
  use CSysWeb, :view

  def render("jianjie.json", %{jianjie: jianjie}) do
    # jianjie |> IO.inspect(label: ">> Normal.JianjieView::render#jianjie.json\n")
    %{
      data: %{url: jianjie.url }
    }
  end

end
