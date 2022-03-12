defmodule Cam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ok = File.mkdir_p("/home/pi/clips")
    :ok = File.mkdir_p("/home/pi/converted")

    children = [
      {MuonTrap.Daemon, ["python", ["watch.py"]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cam.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
