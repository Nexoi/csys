defmodule CSys.AuthTest do
  use CSys.DataCase

  alias CSys.Auth

  describe "users" do
    alias CSys.Auth.User

    @valid_attrs %{is_active: true, uid: "some uid", password: "some password"}
    @update_attrs %{is_active: false, uid: "some updated uid", password: "some updated password"}
    @invalid_attrs %{is_active: nil, uid: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [%User{user | password: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      # assert Auth.get_user!(user.id) == user
      assert Auth.get_user!(user.id) == %User{user | password: nil}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.is_active == true
      assert user.uid == "some uid"
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.is_active == false
      assert user.uid == "some updated uid"
      assert Bcrypt.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      # assert user == Auth.get_user!(user.id)

      assert %User{user | password: nil} == Auth.get_user!(user.id)
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    # 权限验证
    test "authenticate_user/2 authenticates the user" do
      user = user_fixture()
      assert {:error, "Sorry! You do not have authentication to sign in this site."} = Auth.authenticate_user("wrong uid", "")
      assert {:ok, authenticated_user} = Auth.authenticate_user(user.uid, @valid_attrs.password)
      assert %User{user | password: nil} == authenticated_user
    end
  end
end
