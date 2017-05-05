alias App.{Repo, User}

case Repo.get_by(User, username: "ldmw") do
  nil ->
    Repo.insert! %User{
      username: "ldmw",
      password: System.get_env("ADMIN_PASSWORD"),
      password_hash: Comeonin.Bcrypt.hashpwsalt(System.get_env("ADMIN_PASSWORD"))
    }
  _user -> IO.puts "Admin already in database"
end
