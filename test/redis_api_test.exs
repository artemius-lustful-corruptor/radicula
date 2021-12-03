defmodule Radicula.RedisApiTest do
  use ExUnit.Case

  alias Radicula.RedisSrv

  describe "basic redis clent tests" do
    setup do
      {:ok, pid} = RedisSrv.start_link() |> IO.inspect()
      {:ok, %{}}
    end

    test "setting values to redis list and reading from it" do

      range = 1..1000
      Enum.each(range, fn x ->
        n = :rand.uniform(1000) + 1
        RedisSrv.set(n)
        RedisSrv.get()
      end)

      assert RedisSrv.set("term") == "1"
      assert RedisSrv.get() == "term"
    end
  end
end
