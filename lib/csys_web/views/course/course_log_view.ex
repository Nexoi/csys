defmodule CSysWeb.LogView do
  use CSysWeb, :view

  def render("log_page.json", %{page: page}) do
    %{
      data: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_entries: page.total_entries,
        total_pages: page.total_pages,
        data: render_many(page.entries, CSysWeb.LogView, "log.json")
      }
    }
  end

  def render("log.json", %{log: log}) do
    %{
      id: log.id,
      property: log.property,
      detail: log.detail
    }
  end

  def render("log_with_user.json", %{log: log}) do
    %{
      id: log.id,
      property: log.property,
      detail: log.detail,
      user_id: log.user.id,
      user_uid: log.user.uid,
      user_name: log.user.name
    }
  end

end
