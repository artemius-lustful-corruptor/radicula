defmodule Radicula.GeneratorSrv do
  use GenServer

  require Logger

  @n 1000
  @interval 1000
  # Client

  def start_link(%{id: _id, n: _n} = state)  do
    GenServer.start_link(__MODULE__, state)
  end

  def start_link(_), do: Logger.error("Failed start")


  # Server

  @impl true
  def init(state) do
    scheduled_run()
    {:ok, state}
  end



  @impl true
  def handle_info(:update, state) do
    r = :rand.uniform(@n) + 1
    IO.inspect("#{state.id}-#{r}")
    scheduled_run()
    {:noreply, state}
  end


  # HELPERS

  def scheduled_run() do
    Process.send_after(self(), :update, @interval)
  end

end
