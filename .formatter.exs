[
  import_deps: [:ecto, :ecto_sql, :phoenix, :ash, :ash_authentication_phoenix, :ash_postgres, :surface],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Surface.Formatter.Plugin],
  inputs: [
  "*.{heex,ex,exs}",
  "{config,lib,test}/**/*.{heex,ex,exs}",
  "priv/*/seeds.exs",
  "{lib,test}/**/*.sface"
]
]
