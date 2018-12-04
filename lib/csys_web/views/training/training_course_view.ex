defmodule CSysWeb.TrainingCourseView do
  use CSysWeb, :view
  alias CSysWeb.TrainingCourseView

  def render("index.json", %{training_courses: page}) do
    %{
      data: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_entries: page.total_entries,
        total_pages: page.total_pages,
        data: render_many(page.entries, TrainingCourseView, "training_course.json")
      }
    }
  end

  def render("index_with_status.json", %{training_courses: page}) do
    %{
      data: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_entries: page.total_entries,
        total_pages: page.total_pages,
        data: render_many(page.entries, TrainingCourseView, "training_course_with_status.json")
      }
    }
  end

  # def render("index.json", %{training_courses: training_courses}) do
  #   %{data: render_many(training_courses, TrainingCourseView, "training_course.json")}
  # end

  def render("show.json", %{training_course: training_course}) do
    %{data: render_one(training_course, TrainingCourseView, "training_course.json")}
  end

  def render("training_course.json", %{training_course: training_course}) do
    %{
      id: training_course.id,
      major: %{
        id: training_course.major.id,
        name: training_course.major.name
      },
      course_code: training_course.course_code,
      course_name: training_course.course_name,
      course_time: training_course.course_time,
      course_credit: training_course.course_credit,
      course_property: training_course.course_property,
      updated_at: training_course.updated_at,
      inserted_at: training_course.inserted_at
    }
  end

  def render("training_course_with_status.json", %{training_course: training_course}) do
    %{
      id: training_course.id,
      major: %{
        id: training_course.major_id,
      },
      course_code: training_course.course_code,
      course_name: training_course.course_name,
      course_time: training_course.course_time,
      course_credit: training_course.course_credit,
      course_property: training_course.course_property,
      status: training_course.status,
      updated_at: training_course.updated_at,
      inserted_at: training_course.inserted_at
    }
  end
end
