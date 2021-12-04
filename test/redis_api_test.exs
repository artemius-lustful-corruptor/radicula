defmodule Radicula.RedisApiTest do
  use ExUnit.Case

  alias Radicula.RedisSrv

  describe "basic redis client tests for" do
    setup do
      {:ok, client} = RedisSrv.start_link([])

      context = %{
        random_n: :rand.uniform(1000) + 1,
        client: client,
        set: Application.get_env(:radicula, :redis_set),
        list: Application.get_env(:radicula, :redis_list)
      }

      on_exit(fn -> clear_redis(context) end)

      {:ok, context}
    end

    test "setting value to list" do
      range = 1..1000

      Enum.each(range, fn x ->
        n = :rand.uniform(1000) + 1
        RedisSrv.set(:list, n)
        RedisSrv.pop(1)
      end)

      assert RedisSrv.set(:list, "end") == "1"
      assert RedisSrv.pop(1) == ["end"]
    end

    test "setting value to  set", %{random_n: n, set: s} do
      assert RedisSrv.set(:set, n) == "1"
      RedisSrv.remove(s, n)
      assert RedisSrv.get_members(s) == []
    end
  end

  #FIXME move that code to helpers
  defp clear_redis(context) do
    %{list: l, set: s} = context

    [l, s]
    |> Enum.map(&Exredis.Api.del(&1))
  end
end
