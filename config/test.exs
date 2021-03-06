import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ascii_canvas, AsciiCanvas.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "1234",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: "ascii_canvas_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ascii_canvas, AsciiCanvasWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "O1/L/qSUdhZOBLnLTakQlRZzrwBbFzHL0uW67IyAsK9zaopNiLlCuV9uInYpUcTF",
  server: false

# In test we don't send emails.
config :ascii_canvas, AsciiCanvas.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
