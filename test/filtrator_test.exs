defmodule Radicula.FiltratorTest do
  use ExUnit.Case

  alias Radicula.{Filtrator, RedisSrv}

  describe "filtrator test for:" do
    setup do
      {:ok, client} = RedisSrv.start_link()

      on_exit(fn ->
        Exredis.Api.del(:stest)
      end)

      {:ok, %{}}
    end

    test "setting prime value to redis set" do
      # the 1000's prime number
      value = 7919
      Filtrator.filter_prime(value, :set)
      assert RedisSrv.get_members(:stest) == ["7919"]
    end

    test "ignoring regular value" do
      value = 7918
      Filtrator.filter_prime(value, :set)
      assert RedisSrv.get_members(:stest) == []
    end

    test "mixing values" do
      1..7920
      |> Enum.each(&Filtrator.filter_prime(&1, :set))

      length = RedisSrv.get_members(:stest) |> length()
      assert length == 1000
    end
  end
end
