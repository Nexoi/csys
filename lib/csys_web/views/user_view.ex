defmodule CSysWeb.UserView do
  use CSysWeb, :view
  alias CSysWeb.UserView

  def render("page.json", %{page: page}) do
    %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages,
      data: render_many(page.entries, UserView, "user.json")
    }
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      uid: user.uid,
      # password: user.password,
      role: user.role,
      name: user.name,
      major: user.major,
      class: user.class,
      is_active: user.is_active,
      status: if user.status == 1 do "可选课" else "禁止选课" end
    }
  end

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          uid: user.uid,
          role: user.role,
          name: user.name,
          major: user.major,
          class: user.class
        }
      }
    }
  end
end
