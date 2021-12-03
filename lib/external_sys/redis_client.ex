defmodule Radicula.RedisClient do
  import Exredis.Api

  # API functions

  def get_client() do
    Exredis.start_link()
  end

  def pop(client, key) do
    client |> lpop(key)
  end

  def push(client, key, value) do
    client |> lpush(key, value)
  end

  def set(client, key, value) do
    client |> sadd(key, value)
  end

  def get_members(client, type, key) do
    case type do
      :set ->  client |> smembers(key)
    end
  end

  def length(client, key) do
    client |> llen(key)
  end

  # HELPERS



end
