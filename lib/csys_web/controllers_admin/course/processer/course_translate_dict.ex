defmodule CSys.CourseTranslanter.Dictor do
  def unit(nil), do: ""
  def unit(""), do: ""
  def unit(str) do
    case str do
      "物理系" -> "Department of Physics"
      "化学系" -> "Department of Chemistry"
      "生物系" -> "Department of Biology"
      "生物医学工程系" -> "Department of Biomedical Engineering"
      "电子与电气工程系" -> "Department of Electrical and Electronic Engineering"
      "材料科学与工程系" -> "Department of Materials Science and Engineering"
      "金融系" -> "Department of Finance"
      "数学系" -> "Department of Mathematics"
      "计算机科学与工程系" -> "Department of Computer Science and Engineering"
      "环境科学与工程学院" -> "School of Environmental Science and Engineering"
      "力学与航空航天工程系" -> "Department of Mechanics and Aerospace Engineering"
      "机械与能源工程系" -> "Department of Mechanical and Energy Engineering"
      "海洋科学与工程系" -> "Department of Ocean Science and Engineering"
      "地球与空间科学系" -> "Department of Earth and Space Sciences"
      "医学院" -> "School of Medicine"
      "公共基础课部" -> "Department of General Education"
      "语言中心" -> "Language Center"
      "社会科学中心" -> "Social Science Center"
      _ -> str
    end
  end

  def location(nil), do: ""
  def location(""), do: ""
  def location(str) do
    str
    |> String.replace("教工羽毛球场", "Faculty Badminton Court ")
    |> String.replace("足球场", "Football Field ")
    |> String.replace("羽毛球场", "Badminton Court ")
    |> String.replace("乒乓球馆", "Table Tennis Hall ")
    |> String.replace("沿湖舞蹈房", "Lakeside Dance Room ")
    |> String.replace("游泳馆", "The Swimming Pool ")
    |> String.replace("一科报告厅", "Faculty Research Building Lecture Hall ")
    |> String.replace("图书馆报告厅", "Library Lecture Hall ")
    |> String.replace("教工之家", "Faculty Club ")
    |> String.replace("沿湖健身房", "Lakeside Gym ")
    |> String.replace("排球场", "Volleyball Court ")
    |> String.replace("田径场", "Track and Field ")
    |> String.replace("篮球场", "Basketball Courts ")
    |> String.replace("一科", "Faculty Research Building 1 ")
    |> String.replace("二科", "Faculty Research Building 2 ")
    |> String.replace("风雨操场", "Sports Center ")
    |> String.replace("网球场", "Tennis Court ")
    |> String.replace("检测中心", "Materials Characterization ＆Preparation Building ")
    |> String.replace("荔园", "Lichee Hills Block ")
    |> String.replace("智园", "iPart ")
    |> String.replace("一教", "Teaching Building I ")
    |> String.replace("二教", "Teaching Building II ")
  end


  def group(nil), do: ""
  def group(""), do: ""
  def group(str) do
    str
    |> String.replace("英文", "English ")
    |> String.replace("中文", "Chinese ")
    |> String.replace("实验", "Lab ")
    |> String.replace("中英双语", "Bilingual ")
    |> String.replace("中英", "Bilingual ")
    |> String.replace("基础课", "General ")
    |> String.replace("网球", "Tennis ")
    |> String.replace("乒乓球", "Table Tennis ")
    |> String.replace("运动与体能", "Sports and Stamina ")
    |> String.replace("武术", "Martial Arts ")
    |> String.replace("游泳", "Swimming ")
    |> String.replace("篮球", "Basketball ")
    |> String.replace("足球", "Football ")
    |> String.replace("排球", "Volleyball ")
    |> String.replace("棒球", "Baseball")
    |> String.replace("羽毛球", "Badminton ")
    |> String.replace("健身", "Fitness ")
    |> String.replace("健美操", "Aerobics ")
    |> String.replace("体育舞蹈", "Sports Dance ")
    |> String.replace("户外运动", "Outdoor Sports ")
    |> String.replace("定向越野", "Orienteering ")
    |> String.replace("散打", "Free Combat ")
    |> String.replace("瑜伽", "Yoga ")
    |> String.replace("健美", "Bodybuilding ")
    |> String.replace("习题", "Seminar ")
    |> String.replace("秋季学期1-3周不退不补选", "Can’t be added or withdrawn at the first three weeks of the fall semester")
    |> String.replace("国际生", "International students Class")
    |> String.replace("秋季学期1-3周只退不补选", "Can only be withdrawn and can’t be added at the first three weeks of the fall semester")
    |> String.replace("后置名单", "") # （暂时不翻译，隐去）
    |> String.replace("中英双语-实验", "Bilingual Class-Lab ")
    |> String.replace("选择计算机专业或通信工程专业学生修读", "Only for Computer Science and Technology program and Communication Engineering program")
    |> String.replace("建议选择非计算机专业和非通信工程专业学生修读", "For all programs except Computer Science and Technology program and Communication Engineering program")
    |> String.replace("建议选择非计算机专业学生修读", "For all programs except Computer Science and Technology program")
    |> String.replace("选择计算机专业的学生修读", "Only for Computer Science and Technology program")
    |> String.replace("实验课每次都计入期末成绩，且没有补课", "实验课每次都计入期末成绩，且没有补课")
    |> String.replace("Lab课每次都计入成绩", "Every lab will be counted into the final score")
    |> group_class()
  end
  @doc """
  CSys.CourseTranslanter.Dictor.group_class("游泳1班")
  """
  def group_class(str) do
    if str |> String.contains?("班") do
      Regex.replace(~r/[0-9]*班/, str, fn which, _ ->
        # ">> #{which}" |> IO.puts
        num = which |> String.replace("班", "")
        "Class #{num} "
      end)
    else
      str
    end
  end

  def location_detail(nil), do: ""
  def location_detail(""), do: ""
  def location_detail(str) do
    str
    |> location
    # |> string_add_space
    |> location_detail_class_builing
    |> location_detail_class_jifang
    |> String.trim
  end
  def location_detail_class_builing(str) do
    if str |> String.contains?("栋") do
      Regex.replace(~r/[0-9]*栋/, str, fn which, _ ->
        # ">> #{which}" |> IO.puts
        num = which |> String.replace("栋", "")
        "#{num} "
      end)
    else
      str
    end
  end
  def location_detail_class_jifang(str) do
    if str |> String.contains?("机房") do
      Regex.replace(~r/[0-9]*机房/, str, fn which, _ ->
        # ">> #{which}" |> IO.puts
        num = which |> String.replace("机房", "")
        "Computer Room #{num}"
      end)
    else
      str
    end
  end
  def string_add_space(str) do
    "#{str} "
  end

  def teacher(nil), do: ""
  def teacher(""), do: ""
  def teacher(str) do
    if str |> String.contains?(",") do
      str |> teacher_split()
    else
      str
      |> trans_name
      |> Enum.reduce(fn src, new ->
        "#{src}, #{new}"
      end)
      |> cut_suffix_space
      |> String.replace(",", "")
    end
  end
  def teacher_split(str) do
    str
    |> String.split(",")
    |> Enum.map(fn name ->
      name |> trans_name()
    end)
    |> Enum.reduce(fn src, new ->
      "#{src}, #{new}"
    end)
    |> cut_suffix_space
    |> String.replace(" ,", ",")
  end

  def trans_name(name) do
    name
    |> Pinyin.from_string
    |> String.trim
    |> String.split(" ")
    |> Enum.map(fn word ->
      if word |> String.length > 0 do
        # 首字母大写
        prefix = word |> String.slice(0, 1)
        suffix = word |> String.slice(1, 1000)
        "#{prefix |> String.upcase}#{suffix} "
      end
    end)
    |> Enum.filter(fn word ->
      case word do
        nil -> false
        "" -> false
        _ -> true
      end
    end)
  end

  def cut_suffix_space(name) do
    len = name |> String.length
    if len > 0 do
      name |> String.slice(0, len - 1)
    end
  end
end
