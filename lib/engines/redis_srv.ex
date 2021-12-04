defmodule Radicula.RedisSrv do
  @moduledoc """
  Redis's worker server with client in state
  """

  use GenServer

  alias Radicula.RedisClient, as: R

  @list Application.get_env(:radicula, :redis_list)

  # Client Api

  @doc false
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Synchronous request for setting value for Redis set or list
  """
  @spec set(atom(), integer()) :: String.t()
  def set(type, value)

  def set(type, value) do
    GenServer.call(__MODULE__, {:set, {type, value}})
  end

  @doc """
  Synchronous request for poping batched values from Redis list
  """
  @spec pop(integer()) :: any()
  def pop(batch_size)

  def pop(batch_size) do
    GenServer.call(__MODULE__, {:get, @list, batch_size})
  end

  @doc """
  Synchronous request for getting members from Redis set
  """
  @spec get_members(atom()) :: any()
  def get_members(key)

  def get_members(key) do
    GenServer.call(__MODULE__, {:get_members, key})
  end

  @doc """
  Synchronous request for removing key from Redis set
  """
  @spec remove(atom(), String.t()) :: any()
  def remove(queue, key)

  def remove(queue, key) do
    GenServer.call(__MODULE__, {:remove, queue, key})
  end

  @doc """
  Synchronous request for getting length from Redis list
  """
  @spec length(atom()) :: integer()
  def length(queue)

  def length(queue) do
    GenServer.call(__MODULE__, {:length, queue})
  end

  # Callbacks
  @doc false
  @impl true
  def init(state) do
    {:ok, state, {:continue, :get_client}}
  end

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
  def handle_call({:get, key, batch_size}, _, state) do
    %{client: client} = state
    res = client |> R.pop(key, batch_size)
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
