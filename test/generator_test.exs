defmodule Radicula.GeneratorTest do
  use ExUnit.Case

  alias Radicula.RedisSrv
  alias Radicula.GeneratorSuperviser, as: GS

  describe "generator test to" do
    setup do
      {:ok, client} = RedisSrv.start_link([])

      context = %{
        client: client,
        servers: Application.get_env(:radicula, :servers),
        bound: Application.get_env(:radicula, :bound),
        set: Application.get_env(:radicula, :redis_set),
        list: Application.get_env(:radicula, :redis_list)
      }

      on_exit(fn -> clear_list(context) end)

      {:ok, context}
    end

    test "start server for 1 second", context do
      %{servers: s, bound: b, list: l} = context
      length = RedisSrv.length(l) |> String.to_integer()
      assert length == 0
      start_supervised({GS, %{servers: s, bound: b}})
      :timer.sleep(1000)
      stop_supervised(GS)
      length = RedisSrv.length(l) |> String.to_integer()
      assert length == s
    end

    test "frequency measure for 10 seconds", context do
      %{servers: s, bound: b, list: l} = context
      seconds = 20

      start_supervised({GS, %{servers: s, bound: b}})
      :timer.sleep(1000 * seconds)
      stop_supervised(GS)
      length = RedisSrv.length(l) |> String.to_integer()
      assert s - length / seconds < 200
    end
  end

  defp clear_list(%{list: l}) do
    Exredis.Api.del(l)
  end
end
