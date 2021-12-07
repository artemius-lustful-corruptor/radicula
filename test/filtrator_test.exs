defmodule Radicula.FiltratorTest do
  use ExUnit.Case

  alias Radicula.{Filtrator, RedisSrv, GeneratorSuperviser, FiltratorSrv}

  describe "filtrator test for:" do
    setup do
      {:ok, client} = RedisSrv.start_link([])

      set = Application.get_env(:radicula, :redis_set)
      list = Application.get_env(:radicula, :redis_list)

      context = %{
        client: client,
        set: set,
        servers: Application.get_env(:radicula, :servers),
        bound: Application.get_env(:radicula, :bound)
      }

      on_exit(fn ->
        Exredis.Api.del(set)
        Exredis.Api.del(list)
      end)

      {:ok, context}
    end

    test "setting prime value to redis set", %{set: s} do
      # the 1000's prime number
      value = "7919"
      Filtrator.filter_prime(value, :set)
      assert RedisSrv.get_members(s) == ["7919"]
    end

    test "ignoring regular value", %{set: s} do
      value = "7918"
      Filtrator.filter_prime(value, :set)
      assert RedisSrv.get_members(s) == []
    end

    test "mixing values", %{set: s} do
      1..7920
      |> Enum.each(fn x ->
        Integer.to_string(x)
        |> Filtrator.filter_prime(:set)
      end)

      length = RedisSrv.get_members(s) |> length()
      assert length == 1000
    end

    test "filtration with server", context do
      %{servers: srvs, bound: b, set: set} = context
      start_supervised({GeneratorSuperviser, %{servers: srvs, bound: b}})
      FiltratorSrv.start_link([])
      :timer.sleep(10 * 1000)
      assert RedisSrv.get_members(set) |> length() > 0
      stop_supervised(GeneratorSuperviser)
    end
  end
end
