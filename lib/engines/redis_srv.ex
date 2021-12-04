defmodule Radicula.RedisSrv do
  use GenServer

  alias Radicula.RedisClient, as: R

  # Client Api

  @doc false
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def set(type, value) do
    GenServer.call(__MODULE__, {:set, {type, value}})
  end

  def pop() do
    # FIXME get value from config
    GenServer.call(__MODULE__, {:get, :ltest})
  end

  def get_members(key) do
    GenServer.call(__MODULE__, {:get_members, key})
  end

  def remove(queue, key) do
    GenServer.call(__MODULE__, {:remove, queue, key})
  end

  def length(queue) do
    GenServer.call(__MODULE__, {:length, queue})
  end

  # Server
  @doc false
  @impl true
  def init(state) do
    {:ok, state, {:continue, :get_client}}
  end

  # Callbacks
  @doc false
  @impl true
  def handle_continue(:get_client, state) do
    {:ok, client} = R.get_client()
    new_state = Map.put(state, :client, client)
    {:noreply, new_state}
  end

  @doc false
  @impl true
  def handle_call({:set, {type, value}}, _, state) do
    %{client: client} = state
    res = set(client, type, value)
    {:reply, res, state}
  end

  @doc false
  @impl true
  def handle_call({:get, key}, _, state) do
    %{client: client} = state
    res = client |> R.pop(key)
    {:reply, res, state}
  end

  @doc false
  @impl true
  def handle_call({:length, queue}, _, state) do
    %{client: client} = state
    res = client |> R.length(queue)
    {:reply, res, state}
  end

  @doc false
  @impl true
  def handle_call({:get_members, key}, _, state) do
    %{client: client} = state
    res = client |> R.get_members(key)
    {:reply, res, state}
  end

  @doc false
  @impl true
  def handle_call({:remove, queue, key}, _, state) do
    %{client: client} = state
    res = client |> R.remove(queue, key)
    {:reply, res, state}
  end

  # FIX ME creating monitor
  @doc false
  @impl true
  def terminate(reason, %{client: client}) do
    client |> Exredis.stop()
  end

  # HELPERS

  defp set(client, type, value) do
    case type do
      :list ->
        key = :ltest
        client |> R.push(key, value)

      :set ->
        key = :stest
        client |> R.set(key, value)
    end
  end
end
