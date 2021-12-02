defmodule Radicula.RedisSrv do
  import Exredis.Api

  # API

  #TODO
  """
  . Writing test for writing and reading redis_api.ex to testing redis docker container
  0. Creating generator_api, filtrator_api, redis_api, generator_test, filtrator_test, generator_srv, filtrator_srv, generator_superviesr
  1. Integrate Redis client into generator_srv, filtrator_srv *terminate case
  3. Creating api modules for Redis: [set, get, isPrime?]
  4. Testing for read and write to list

  docker run -p 6379:6379 --name redis_cont -e ALLOW_EMPTY_PASSWORD=yes bitnami/redis:latest

  """

  def set(client) do
    # {:ok, client} = get_client()
    client |> set("worker_1", 333)
    #client |> Exredis.stop()
  end

  def get(client) do
    # {:ok, client} = get_client()
    client |> get("worker_1")
    #client |> Exredis.stop()
  end

  defp get_client() do
    Exredis.start_link()
  end
end
