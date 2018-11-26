defmodule CSys.CourseProcesser do
  @doc """
  CSysWeb.CourseProcesser.convert("1-4周 星期一 0304节<br>1-4周 星期四 0102节<br>1-4周 星期三 0304节<br>1-4周 星期二 0102节", "荔园2栋303<br>荔园2栋304<br>荔园2栋305<br>荔园2栋306")
  time: 1-4周 星期一 0304节<br>1-4周 星期四 0102节<br>1-4周 星期三 0304节<br>1-4周 星期二 0102节
  location: 荔园2栋303<br>荔园2栋304<br>荔园2栋305<br>荔园2栋306
  """
  def convert(time, location) do
    times = time |> String.split("节<br>")
    locations = location |> String.split("<br>")
    Stream.zip([times, locations])
    |> Enum.to_list()
    |> Enum.map(fn {t, l} ->
      convert_together(t, l)
    end)
  end

  def convert_together(str, location) do
    strs = str |> String.split(" ")
    {weeks, _} = strs |> List.pop_at(0)
    {days, _} = strs |> List.pop_at(1)
    {times, _} = strs |> List.pop_at(2)
    %{
      week: convert_week(weeks),
      day: convert_day(days),
      time: convert_time(times),
      location: location
    }
  end

  def convert_week(src_str) do
    str = src_str |> String.replace("周", "")
    IO.inspect str
    if str |> String.contains?("-") do
      IO.puts "含有 -"
      if str |> String.contains?("<br>") do
        IO.puts "含有 <br>"
        weeks_ = str |> String.split("<br>")
        Enum.map(weeks_, fn x ->
          if x |> String.contains?("-") do
            weeks = x |> String.split("-")
            {start_, _} = weeks |> List.pop_at(0)
            {end_, _} = weeks |> List.pop_at(1)
            start_num = start_ |> String.to_integer
            end_num = end_ |> String.to_integer
            # start_num..end_num
            IO.inspect [start_num, end_num]
            Enum.map(start_num..end_num, fn x -> x end)
          else
            [x |> String.to_integer]
          end
        end)
      else
        IO.puts "点到点打，4-8、9-16"
        weeks = str |> String.split("-")
        {start_, _} = weeks |> List.pop_at(0)
        {end_, _} = weeks |> List.pop_at(1)
        start_num = start_ |> String.to_integer
        end_num = end_ |> String.to_integer
        # start_num..end_num
        IO.inspect [start_num, end_num]
        Enum.map(start_num..end_num, fn x -> x end)
      end
    else
      IO.puts "直接一串打，1、3、5、7、9..."
      if str |> String.contains?("<br>") do
        weeks = str |> String.split("<br>")
        IO.inspect weeks
        Enum.map(weeks, fn x -> x |> String.to_integer end)
      else
        [str |> to_integer]
      end
    end
  end

  def convert_day(str) do
    case str do
      "星期一" -> 1
      "星期二" -> 2
      "星期三" -> 3
      "星期四" -> 4
      "星期五" -> 5
      "星期六" -> 6
      "星期日" -> 7
      other -> 7
    end
  end

  def convert_time(nil) do [] end
  def convert_time(src_str) do
    str = src_str |> String.replace("节", "")
    length = str |> String.length
    if Integer.mod(length, 2) == 0 do # 合法
      count = (length / 2 |> round) - 1
      Enum.map(0..count, fn i ->
        str |> String.slice(i * 2, 2) |> String.to_integer
      end)
    end
  end

  def convert_boolean("否") do
    false
  end
  def convert_boolean("是") do
    true
  end
  def convert_boolean("开放") do
    true
  end
  def convert_boolean("关闭") do
    false
  end

  def to_string(nil) do
    nil
  end
  def to_string("") do
    nil
  end
  def to_string(str) do
    str
  end
  def to_integer(nil) do
    0
  end
  def to_integer("") do
    0
  end
  def to_integer(str) do
    str |> String.to_integer
  end
  def to_float(nil) do
    nil
  end
  def to_float("") do
    nil
  end
  def to_float(str) do
    if str |> String.contains?(".") do
      str |> String.to_float
    else
      str |> String.to_integer
    end
  end

end
