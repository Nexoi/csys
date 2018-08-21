defmodule CSysWeb.CourseView do
  use CSysWeb, :view

  def render("courses_page.json", %{courses_page: page}) do
    %{
      data: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_entries: page.total_entries,
        total_pages: page.total_pages,
        data: render_many(page.entries, CSysWeb.CourseView, "course.json")
      }
    }
  end

  def render("courses.json", %{courses: courses}) do
    %{data: render_many(courses, CSysWeb.CourseView, "course.json")}
  end

  def render("course.json", %{course: c}) do
    %{
      class_name: c.class_name,
      code: c.code,
      compus: c.compus,
      credit: c.credit,
      current_num: c.current_num,
      gender_req: c.gender_req,
      group_name: c.group_name,
      id: c.id,
      inserted_at: c.inserted_at,
      is_active: c.is_active,
      is_stop: c.is_stop,
      limit_num: c.limit_num,
      name: c.name,
      notification_cate: c.notification_cate,
      property: c.property,
      seat_num: c.seat_num,
      suzhi_cate: c.suzhi_cate,
      teacher: c.teacher,
      time: c.time,
      unit: c.unit,
      updated_at: c.updated_at,
      venue: c.venue
    }
  end

end
