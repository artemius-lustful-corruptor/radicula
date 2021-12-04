defmodule Radicula.GeneratorTest do
  use ExUnit.Case

  alias Radicula.RedisSrv
  alias Radicula.GeneratorSuperviser, as: GS

  describe "generator test to" do
    setup do
      {:ok, client} = RedisSrv.start_link()

      context = %{
        client: client
      }

      on_exit(&clear_list/0)

      {:ok, context}
    end

    test "start server for 1 second", %{client: rc} do
      length = RedisSrv.length(:ltest) |> String.to_integer()
      assert length == 0
      GS.start_link()
      :timer.sleep(1000)
      GS.stop()
      length = RedisSrv.length(:ltest) |> String.to_integer()
      assert length == 3000
    end

    test "frequency measure for 10 seconds", %{client: rc} do
      seconds = 20
      GS.start_link()
      :timer.sleep(1000 * seconds)
      GS.stop()
      length = RedisSrv.length(:ltest) |> String.to_integer()
      assert 3000 - length / seconds < 400
    end
  end

  defp clear_list() do
    Exredis.Api.del(:ltest)
  end
end
