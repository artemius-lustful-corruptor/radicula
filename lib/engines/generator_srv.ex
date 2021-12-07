defmodule Radicula.GeneratorSrv do
  @moduledoc false
  use GenServer
  require Logger

  alias Radicula.Generator

  @interval Application.get_env(:radicula, :interval)
  # Client

  def start_link(%{id: _id, bound: _n} = state) do
    GenServer.start_link(__MODULE__, state)
  end

  def start_link(_), do: Logger.error("Failed start")

  # Server

  @impl true
  def init(state) do
    schedule()
    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    Generator.generate_number(state.bound)

    schedule()
    {:noreply, state}
  end

  # HELPERS

  defp schedule() do
    Process.send_after(self(), :update, @interval)
  end
end
