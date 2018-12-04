defmodule CSysWeb.TrainingMajorControllerTest do
  use CSysWeb.ConnCase

  alias CSys.Training
  alias CSys.Training.TrainingMajor

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:training_major) do
    {:ok, training_major} = Training.create_training_major(@create_attrs)
    training_major
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all training_majors", %{conn: conn} do
      conn = get conn, training_major_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create training_major" do
    test "renders training_major when data is valid", %{conn: conn} do
      conn = post conn, training_major_path(conn, :create), training_major: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, training_major_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, training_major_path(conn, :create), training_major: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update training_major" do
    setup [:create_training_major]

    test "renders training_major when data is valid", %{conn: conn, training_major: %TrainingMajor{id: id} = training_major} do
      conn = put conn, training_major_path(conn, :update, training_major), training_major: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, training_major_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, training_major: training_major} do
      conn = put conn, training_major_path(conn, :update, training_major), training_major: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete training_major" do
    setup [:create_training_major]

    test "deletes chosen training_major", %{conn: conn, training_major: training_major} do
      conn = delete conn, training_major_path(conn, :delete, training_major)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, training_major_path(conn, :show, training_major)
      end
    end
  end

  defp create_training_major(_) do
    training_major = fixture(:training_major)
    {:ok, training_major: training_major}
  end
end
