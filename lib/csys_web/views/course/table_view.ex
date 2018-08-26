defmodule CSysWeb.TableView do
  use CSysWeb, :view

  def render("table_page.json", %{table_page: page}) do
    %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages,
      data: render_many(page.entries, CSysWeb.TableView, "table_item_only_course.json")
    }
  end

  def render("table_page_with_user.json", %{table_page: page}) do
    %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages,
      data: render_many(page.entries, CSysWeb.TableView, "table_item_only_user.json")
    }
  end

  def render("table_only_courses.json", %{table: table}) do
    %{data: render_many(table, CSysWeb.TableView, "table_item_only_course.json")}
  end

  def render("table.json", %{table: table}) do
    %{data: render_many(table, CSysWeb.TableView, "table_item.json")}
  end

  def render("table_item.json", %{table: table}) do
    # table.term |> IO.inspect(label: ">> table.term")
    %{
      term: render_one(table.term, CSysWeb.TableView, "term.json"),
      course: render_one(table.course, CSysWeb.TableView, "course.json")
    }
  end

  def render("table_item_only_course.json", %{table: table}) do
    # table.term |> IO.inspect(label: ">> table.term")
    render_one(table.course, CSysWeb.TableView, "course.json")
  end

  def render("table_item_only_user.json", %{table: table}) do
    # table.term |> IO.inspect(label: ">> table.term")
    render_one(table.user, CSysWeb.TableView, "user.json")
  end

  def render("term.json", %{table: term}) do
    # term |> IO.inspect(label: ">> term")
    %{
      term: term.term,
      term_id: term.id,
      term_name: term.name
    }
  end

  def render("user.json", %{table: user}) do
    %{id: user.id,
      uid: user.uid,
      role: user.role,
      name: user.name,
      major: user.major,
      class: user.class,
      is_active: user.is_active
    }
  end

  def render("course.json", %{table: c}) do
    c |> IO.inspect
    %{
      class_name: c.class_name,
      code: c.code,
      compus: c.compus,
      credit: c.credit,
      # current_num: c.current_num,
      gender_req: c.gender_req,
      group_name: c.group_name,
      id: c.id,
      # inserted_at: c.inserted_at,
      # is_active: c.is_active,
      # is_stop: c.is_stop,
      # limit_num: c.limit_num,
      name: c.name,
      notification_cate: c.notification_cate,
      property: c.property,
      # seat_num: c.seat_num,
      suzhi_cate: c.suzhi_cate,
      teacher: c.teacher,
      time: c.time,
      unit: c.unit,
      # updated_at: c.updated_at,
      venue: c.venue
    }
  end

end
