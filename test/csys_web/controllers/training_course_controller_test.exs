defmodule CSysWeb.TrainingCourseControllerTest do
  use CSysWeb.ConnCase

  alias CSys.Training
  alias CSys.Training.TrainingCourse

  @create_attrs %{course_code: "some course_code", course_credit: 42, course_name: "some course_name", course_property: "some course_property", course_time: 42, major_id: 42}
  @update_attrs %{course_code: "some updated course_code", course_credit: 43, course_name: "some updated course_name", course_property: "some updated course_property", course_time: 43, major_id: 43}
  @invalid_attrs %{course_code: nil, course_credit: nil, course_name: nil, course_property: nil, course_time: nil, major_id: nil}

  def fixture(:training_course) do
    {:ok, training_course} = Training.create_training_course(@create_attrs)
    training_course
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all training_courses", %{conn: conn} do
      conn = get conn, training_course_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create training_course" do
    test "renders training_course when data is valid", %{conn: conn} do
      conn = post conn, training_course_path(conn, :create), training_course: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, training_course_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "course_code" => "some course_code",
        "course_credit" => 42,
        "course_name" => "some course_name",
        "course_property" => "some course_property",
        "course_time" => 42,
        "major_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, training_course_path(conn, :create), training_course: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update training_course" do
    setup [:create_training_course]

    test "renders training_course when data is valid", %{conn: conn, training_course: %TrainingCourse{id: id} = training_course} do
      conn = put conn, training_course_path(conn, :update, training_course), training_course: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, training_course_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "course_code" => "some updated course_code",
        "course_credit" => 43,
        "course_name" => "some updated course_name",
        "course_property" => "some updated course_property",
        "course_time" => 43,
        "major_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, training_course: training_course} do
      conn = put conn, training_course_path(conn, :update, training_course), training_course: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete training_course" do
    setup [:create_training_course]

    test "deletes chosen training_course", %{conn: conn, training_course: training_course} do
      conn = delete conn, training_course_path(conn, :delete, training_course)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, training_course_path(conn, :show, training_course)
      end
    end
  end

  defp create_training_course(_) do
    training_course = fixture(:training_course)
    {:ok, training_course: training_course}
  end
end
