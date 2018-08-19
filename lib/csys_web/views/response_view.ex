defmodule CSysWeb.RView do
  use CSysWeb, :view

  def render("201.json", %{data: data}) do
    %{
      message: "资源创建成功",
      data: data
    }
  end

  def render("204.json", %{message: message}) do
    %{message: message}
  end

end
