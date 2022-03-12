defmodule Cam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Enum.each(Cam.directories(), fn(dir) ->
      :ok = File.mkdir_p(dir)
    end)

    children = [
      {MuonTrap.Daemon, ["python", ["watch.py"]]}
      {Cam.Converter, nil}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cam.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
