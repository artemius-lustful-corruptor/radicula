defmodule Radicula.FiltratorSrv do
  @moduledoc false

  use GenServer

  alias Radicula.{RedisSrv, Filtrator}

  @interval Application.get_env(:radicula, :interval)
  @batch_size Application.get_env(:radicula, :batch_size)

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(state) do
    shedule_update()
    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    pop_batch()
    |> filter()

    shedule_update()
    {:noreply, state}
  end

  # Helpers

  defp filter(list) do
    Enum.map(list, &Filtrator.filter_prime(&1, :set))
  end

  defp pop_batch() do
    RedisSrv.pop(@batch_size)
  end

  defp shedule_update() do
    Process.send_after(__MODULE__, :update, @interval)
  end
end
