defmodule Radicula.RedisClient do
  @moduledoc """
  Module for mapping Redis Client Api
  """

  import Exredis.Api,
    only: [
      lpop: 2,
      lpush: 3,
      sadd: 3,
      smembers: 2,
      llen: 2,
      srem: 3
    ]

  # API functions

  @doc """
  Getting Redis client
  """
  @spec get_client() :: {:ok, pid()}
  def get_client()

  def get_client() do
    Exredis.start_link()
  end

  @doc """
  Popping element from Redis list
  """
  @spec pop(pid(), atom(), integer()) :: String.t()
  def pop(client, key, count)

  def pop(client, key, count) do
    client |> lpop([key, count])
  end

  @doc """
  Pushing integer to queue from generator
  """
  @spec push(pid(), atom(), integer()) :: any()
  def push(client, key, value)

  def push(client, key, value) do
    client |> lpush(key, value)
  end

  @doc """
  Setting value to redis's set
  """
  @spec set(pid(), atom(), integer()) :: String.t()
  def set(client, key, value)

  def set(client, key, value) do
    client |> sadd(key, value)
  end

  @doc """
  Getting members from redis's set
  """
  @spec get_members(pid(), atom()) :: any()
  def get_members(client, key)

  def get_members(client, key) do
    client |> smembers(key)
  end

  @doc """
  Getting redis's list length
  """
  @spec length(pid(), atom()) :: any()
  def length(client, queue)

  def length(client, queue) do
    client |> llen(queue)
  end

  @doc """
  Removing queue
  """
  @spec remove(pid(), atom(), String.t()) :: any()
  def remove(client, queue, key)

  def remove(client, queue, key) do
    client |> srem(queue, key)
  end
end
