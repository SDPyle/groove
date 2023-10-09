defmodule GrooveWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ChannelTest
      import GrooveWeb.ChannelCase

      @endpoint GrooveWeb.Endpoint
    end
  end

  setup tags do
    Groove.DataCase.setup_sandbox(tags)
    :ok
  end
end
