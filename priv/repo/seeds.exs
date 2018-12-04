# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CSys.Repo.insert!(%CSys.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

CSys.Auth.create_user(%{
  uid: "11610522",
  name: "test",
  class: "test",
  major: "CS",
  password: "yangxiaosu",
  is_active: true,
  role: "admin"
})
CSys.Auth.create_user(%{
  uid: "11510053",
  name: "test",
  class: "test",
  major: "CS",
  password: "yangxiaosu",
  is_active: true,
  role: "admin"
})