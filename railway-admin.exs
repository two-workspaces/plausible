:ok = Application.ensure_loaded(:plausible)
Enum.each([:ssl, :postgrex, :ch, :ecto], &Application.ensure_all_started/1)
{:ok, _} = Plausible.Repo.start_link(pool_size: 1)

if Plausible.Repo.exists?(Plausible.Auth.User) do
  IO.puts("[railway] users exist, admin not seeded")
else
  email = System.fetch_env!("ADMIN_USER_EMAIL")
  pwd = System.fetch_env!("ADMIN_USER_PWD")

  %{"name" => System.get_env("ADMIN_USER_NAME", "Admin"), "email" => email,
    "password" => pwd, "password_confirmation" => pwd}
  |> Plausible.Auth.User.new()
  |> Plausible.Repo.insert!()

  IO.puts("[railway] admin #{email} created")
end
