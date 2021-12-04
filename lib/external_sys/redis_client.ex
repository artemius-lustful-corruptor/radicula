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

  def get_members(client, key) do
    client |> smembers(key)
  end

  def length(client, queue) do
    client |> llen(queue)
  end

  def remove(client, queue, key) do
    client |> srem(queue, key)
  end

  # HELPERS
end
