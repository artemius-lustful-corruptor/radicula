defmodule Radicula.GeneratorSuperviser do
  @moduledoc """
  Module to supervise generator servers
  """
  use Supervisor

  alias Radicula.GeneratorSrv

  @doc """
  Starting N generator servers
  """
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  Stoping all servers with :normal reason
  """
  def stop() do
    Supervisor.stop(__MODULE__, :normal)
  end

  @doc false
  @impl true
  def init(args) do
    %{servers: s, bound: bound} = args
    children =
      for n <- 1..s do
        Supervisor.child_spec(
          {GeneratorSrv, %{id: n, bound: bound}},
          id: "server_#{n}"
        )
      end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
