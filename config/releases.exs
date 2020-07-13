import Config

db_user = System.fetch_env!("PGUSER")
db_password = System.fetch_env!("PGPASSWORD")
db_database = System.fetch_env!("PGDATABASE")
db_host = System.fetch_env!("PGHOST")
pool_size = System.fetch_env!("POOL_SIZE") # 10

secret_key_base =  System.fetch_env!("SECRET_KEY_BASE") # mix phx.gen.secret
app_port = System.fetch_env!("APP_PORT") # 4001

config :mysolat, Mysolat.Repo,
  # ssl: true,
  username: db_user,
  password: db_password,
  database: db_database,
  hostname: db_host,
  pool_size: String.to_integer(pool_size)

config :mysolat, MysolatWeb.Endpoint,
  http: [
    port: String.to_integer(app_port)  # 4001
  ],
  check_origin: false,
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :mysolat, MysolatWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
