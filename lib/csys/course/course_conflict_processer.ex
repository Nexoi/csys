defmodule CSys.Course.ConflictProcesser do
  alias CSys.CourseDao


  def enhance_conflict_courses(courses, term_id, user_id) do
    courses |> Enum.map(fn course ->
      case judge_dup_course(user_id, term_id, course) do
        {:ok, _} ->
          course |> Map.put(:conflict_courses, "")
        {:error, conflict_course_names} ->
          course |> Map.put(:conflict_courses, conflict_course_names)
      end
    end)
  end
  defp judge_dup_course(user_id, term_id, current_course) do
    courses = list_courses(user_id, term_id)
    if current_venues = current_course.venue do
      # current_venues |> IO.inspect(label: ">>>> CurrentVenue")
      dup_courses =
      courses |> Enum.filter(fn c -> # 遍历课程
        if c do
          if venues = c.venue do
            each_dup_courses =
            venues |> Enum.filter(fn v -> # 遍历课程的节次
              if v do
                # 当前课程当前节 的冲突列表
                item_dup_courses =
                current_venues |> Enum.filter(fn current_venue -> # 循环即将插入的课程的每一节课
                  if current_venue do
                    current_week = current_venue["week"]
                    current_day = current_venue["day"]
                    current_time = current_venue["time"]
                    if is_week_dup(v["week"], current_week) == [] do
                      false
                    else
                      if not is_day_dup(v["day"], current_day) do
                        false
                      else
                        if is_time_dup(v["time"], current_time) == [] do
                          false
                        else
                          true
                        end
                      end
                    end
                  end
                end)
                # |> IO.inspect(label: ">> item_dup_courses")
                item_dup_courses != []
              end
            end)
            # |> IO.inspect(label: ">> each_dup_courses")
            each_dup_courses != []
          end
        end
      end)
      # |> IO.inspect(label: ">>>> Result")

      if dup_courses == [] do
        {:ok, "Time is fine"}
      else
        courses_names = dup_courses |> Enum.map(fn c ->
          "[#{c.code}]#{c.name} \n"
        end)
        {:error, courses_names |> List.to_string}
      end
    else
      {:ok, "Venue is nil"}
    end
  end

  @doc """
  CSys.CourseDao.chose_course(1,1,3)
  CSys.CourseDao.cancel_course(1,1,3)
  判断当前即将插入的 current_course 是否冲突
  CSys.Course.ConflictProcesser.judge_dup(1, 1, 3)
  """
  def judge_dup(user_id, term_id, current_course_id) do
    courses = list_courses(user_id, term_id)
    if course = find_course(current_course_id) do
      if current_venues = course.venue do
        # current_venues |> IO.inspect(label: ">>>> CurrentVenue")
        dup_courses =
        courses |> Enum.filter(fn c -> # 遍历课程
          if c do
            if venues = c.venue do
              each_dup_courses =
              venues |> Enum.filter(fn v -> # 遍历课程的节次
                if v do
                  # 当前课程当前节 的冲突列表
                  item_dup_courses =
                  current_venues |> Enum.filter(fn current_venue -> # 循环即将插入的课程的每一节课
                    # current_venue |> IO.inspect(label: ">> CurrentCourseVenue")
                    if current_venue do
                      current_week = current_venue["week"]
                      current_day = current_venue["day"]
                      current_time = current_venue["time"]
                      # v |> IO.inspect(label: ">>>> Venue")
                      if is_week_dup(v["week"], current_week) == [] do
                        # {:ok, "Week not dup"}
                        # IO.puts("Week not dup")
                        # IO.inspect(v["week"])
                        # IO.inspect(current_week)
                        false
                      else
                        if not is_day_dup(v["day"], current_day) do
                          # {:ok, "Week dup, Day not dup"}
                          # IO.puts("Week dup, Day not dup")
                          # IO.inspect(v["day"])
                          # IO.inspect(current_day)
                          false
                        else
                          if is_time_dup(v["time"], current_time) == [] do
                            # {:ok, "Week, Day dup, Time not dup"}
                            # IO.puts("Week, Day dup, Time not dup")
                            # IO.inspect(v["time"])
                            # IO.inspect(current_time)
                            false
                          else
                            # {:error, "Course Conflict"}
                            # IO.puts("Course Conflict")
                            # %{
                            #   week: v["week"],
                            #   day: v["day"],
                            #   time: v["time"]
                            # }
                            # |> IO.inspect()
                            # %{
                            #   week: current_week,
                            #   day: current_day,
                            #   time: current_time
                            # }
                            # |> IO.inspect()
                            true
                          end
                        end
                      end
                    end
                  end)
                  # |> IO.inspect(label: ">> item_dup_courses")
                  item_dup_courses != []
                end
              end)
              # |> IO.inspect(label: ">> each_dup_courses")
              each_dup_courses != []
            end
          end
        end)
        # |> IO.inspect(label: ">>>> Result")

        if dup_courses == [] do
          {:ok, "Time is fine"}
        else
          courses_names = dup_courses |> Enum.map(fn c ->
            "[#{c.code}]#{c.name} "
          end)
          {:error, "Conflict courses: #{courses_names |> List.to_string}"}
        end
      else
        {:ok, "Venue is nil"}
      end
    else
      {:error, "Course not exist"}
    end
  end

  def find_course(course_id) do
    CourseDao.find_course(course_id)
  end

  def list_courses(user_id, term_id) do
    CourseDao.list_course_tables_all(term_id, user_id)
    |> Enum.map(fn table -> table.course end)
    # |> IO.inspect(label: ">> Courses Maped")
    |> Enum.filter(fn course ->
      course.venue != nil
    end)
    # |> IO.inspect(label: ">> Courses Filter")
  end

  # CSys.Course.ConflictProcesser.is_week_dup([1, 2, 3, 4], [5, 6, 7, 8])
  defp is_week_dup(week, current_week) do
    # IO.inspect(%{
    #   week: week,
    #   current_week: current_week
    # })
    week |> Enum.filter(fn x ->
      if current_week do
        current_week |> Enum.filter(fn y ->
          x == y
        end)
        |> List.first
      end
    end)
    # |> IO.inspect(label: ">>>> Week dup")
  end

  defp is_day_dup(day, current_day) do
    # IO.inspect(%{
    #   day: day,
    #   current_day: current_day
    # })
    day == current_day
    # IO.inspect("#{day} == #{current_day}, r=#{r}")
  end

  defp is_time_dup(time, current_time) do
    # IO.inspect(%{
    #   time: time,
    #   current_time: current_time
    # })
    time |> Enum.filter(fn x ->
      current_time |> Enum.filter(fn y ->
        x == y
      end)
      |> List.first
    end)
  end

end
