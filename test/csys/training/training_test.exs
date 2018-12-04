defmodule CSys.TrainingTest do
  use CSys.DataCase

  alias CSys.Training

  describe "training_courses" do
    alias CSys.Training.TrainingCourse

    @valid_attrs %{course_code: "some course_code", course_credit: 42, course_name: "some course_name", course_property: "some course_property", course_time: 42, major_id: 42}
    @update_attrs %{course_code: "some updated course_code", course_credit: 43, course_name: "some updated course_name", course_property: "some updated course_property", course_time: 43, major_id: 43}
    @invalid_attrs %{course_code: nil, course_credit: nil, course_name: nil, course_property: nil, course_time: nil, major_id: nil}

    def training_course_fixture(attrs \\ %{}) do
      {:ok, training_course} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Training.create_training_course()

      training_course
    end

    test "list_training_courses/0 returns all training_courses" do
      training_course = training_course_fixture()
      assert Training.list_training_courses() == [training_course]
    end

    test "get_training_course!/1 returns the training_course with given id" do
      training_course = training_course_fixture()
      assert Training.get_training_course!(training_course.id) == training_course
    end

    test "create_training_course/1 with valid data creates a training_course" do
      assert {:ok, %TrainingCourse{} = training_course} = Training.create_training_course(@valid_attrs)
      assert training_course.course_code == "some course_code"
      assert training_course.course_credit == 42
      assert training_course.course_name == "some course_name"
      assert training_course.course_property == "some course_property"
      assert training_course.course_time == 42
      assert training_course.major_id == 42
    end

    test "create_training_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_training_course(@invalid_attrs)
    end

    test "update_training_course/2 with valid data updates the training_course" do
      training_course = training_course_fixture()
      assert {:ok, training_course} = Training.update_training_course(training_course, @update_attrs)
      assert %TrainingCourse{} = training_course
      assert training_course.course_code == "some updated course_code"
      assert training_course.course_credit == 43
      assert training_course.course_name == "some updated course_name"
      assert training_course.course_property == "some updated course_property"
      assert training_course.course_time == 43
      assert training_course.major_id == 43
    end

    test "update_training_course/2 with invalid data returns error changeset" do
      training_course = training_course_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_training_course(training_course, @invalid_attrs)
      assert training_course == Training.get_training_course!(training_course.id)
    end

    test "delete_training_course/1 deletes the training_course" do
      training_course = training_course_fixture()
      assert {:ok, %TrainingCourse{}} = Training.delete_training_course(training_course)
      assert_raise Ecto.NoResultsError, fn -> Training.get_training_course!(training_course.id) end
    end

    test "change_training_course/1 returns a training_course changeset" do
      training_course = training_course_fixture()
      assert %Ecto.Changeset{} = Training.change_training_course(training_course)
    end
  end

  describe "training_majors" do
    alias CSys.Training.TrainingMajor

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def training_major_fixture(attrs \\ %{}) do
      {:ok, training_major} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Training.create_training_major()

      training_major
    end

    test "list_training_majors/0 returns all training_majors" do
      training_major = training_major_fixture()
      assert Training.list_training_majors() == [training_major]
    end

    test "get_training_major!/1 returns the training_major with given id" do
      training_major = training_major_fixture()
      assert Training.get_training_major!(training_major.id) == training_major
    end

    test "create_training_major/1 with valid data creates a training_major" do
      assert {:ok, %TrainingMajor{} = training_major} = Training.create_training_major(@valid_attrs)
      assert training_major.name == "some name"
    end

    test "create_training_major/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_training_major(@invalid_attrs)
    end

    test "update_training_major/2 with valid data updates the training_major" do
      training_major = training_major_fixture()
      assert {:ok, training_major} = Training.update_training_major(training_major, @update_attrs)
      assert %TrainingMajor{} = training_major
      assert training_major.name == "some updated name"
    end

    test "update_training_major/2 with invalid data returns error changeset" do
      training_major = training_major_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_training_major(training_major, @invalid_attrs)
      assert training_major == Training.get_training_major!(training_major.id)
    end

    test "delete_training_major/1 deletes the training_major" do
      training_major = training_major_fixture()
      assert {:ok, %TrainingMajor{}} = Training.delete_training_major(training_major)
      assert_raise Ecto.NoResultsError, fn -> Training.get_training_major!(training_major.id) end
    end

    test "change_training_major/1 returns a training_major changeset" do
      training_major = training_major_fixture()
      assert %Ecto.Changeset{} = Training.change_training_major(training_major)
    end
  end
end
