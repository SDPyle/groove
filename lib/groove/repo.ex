defmodule Groove.Repo do
  use AshPostgres.Repo,
    otp_app: :groove

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
