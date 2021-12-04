defmodule Radicula.Generator do
  @moduledoc """
  Module for generation functions
  """

  alias Radicula.RedisSrv, as: RS

  # API

  @spec generate_number(integer()) :: integer()
  def generate_number(bound)

  def generate_number(bound) do
    (:rand.uniform(bound) + 1)
    |> push_to_queue()
  end

  # HELPERS

  defp push_to_queue(value) do
    RS.set(:list, value)
  end
end
