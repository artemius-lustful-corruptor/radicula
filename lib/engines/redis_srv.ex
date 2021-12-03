defmodule Radicula.RedisSrv do
  use GenServer

  alias Radicula.RedisClient, as: R

  # API

  # TODO
  """
  . Writing test for writing and reading redis_api.ex to testing redis docker container
  0. Creating generator_api, filtrator_api, redis_api, generator_test, filtrator_test, generator_srv, filtrator_srv, generator_superviesr
  1. Integrate Redis client into generator_srv, filtrator_srv *terminate case
  3. Creating api modules for Redis: [set, get, isPrime?]
  4. Testing for read and write to list

  docker run -p 6379:6379 --name redis_cont -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest

  """

  # Client Api

  @doc false
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def set(value, type) do
    GenServer.call(__MODULE__, {:set, {type, value}})
  end

  def pop() do
    GenServer.call(__MODULE__, {:get, :ltest})
  end

  def get_members(type, key) do
    GenServer.call(__MODULE__, {:get_members, type, key})
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
  def handle_call({:get_members, type, key}, _, state) do
    %{client: client} = state
    res = client |> R.get_members(type, key)
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
