defmodule Radicula.GeneratorSuperviser do
  use Supervisor

  alias Radicula.GeneratorSrv

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = for n <- 1..3000, do: Supervisor.child_spec({GeneratorSrv, %{id: n, n: :n}}, id: "child_#{n}")
    Supervisor.init(children, strategy: :one_for_one)
  end
end
