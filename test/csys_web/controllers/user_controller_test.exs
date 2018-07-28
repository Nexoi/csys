defmodule CSysWeb.UserControllerTest do
  use CSysWeb.ConnCase

  alias CSys.Auth
  alias CSys.Auth.User
  alias Plug.Test

  @create_attrs %{is_active: true, password: "some password", uid: "some uid"}
  @update_attrs %{is_active: false, password: "some updated password", uid: "some updated uid"}
  @invalid_attrs %{is_active: nil, password: nil, uid: nil}
  @current_user_attrs %{
    uid: "some current user uid",
    is_active: true,
    password: "some current user password"
  }

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@current_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "index" do
    test "lists all users", %{conn: conn, current_user: current_user} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == [
        %{
          "id" => current_user.id,
          "uid" => current_user.uid,
          "is_active" => current_user.is_active
        }
      ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => true,
        # "password" => "some password",
        "uid" => "some uid"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => false,
        # "password" => "some updated password",
        "uid" => "some updated uid"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  describe "sign_in user" do
    test "renders user when user credentials are good", %{conn: conn, current_user: current_user} do
      conn =
        post(
          conn,
          user_path(conn, :sign_in, %{
            uid: current_user.uid,
            password: @current_user_attrs.password
          })
        )

      assert json_response(conn, 200)["data"] == %{
               "user" => %{"id" => current_user.id, "uid" => current_user.uid}
             }
    end

    test "renders errors when user credentials are bad", %{conn: conn} do
      conn = post(conn, user_path(conn, :sign_in, %{uid: "nonexistent uid", password: ""}))
      assert json_response(conn, 401)["errors"] == %{"detail" => "Sorry! You do not have authentication to sign in this site."}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {:ok,
     conn: Test.init_test_session(conn, current_user_id: current_user.id),
     current_user: current_user
    }
  end
end
