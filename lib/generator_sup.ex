defmodule Radicula.GeneratorSuperviser do
  use Supervisor

  alias Radicula.GeneratorSrv

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def stop() do
    Supervisor.stop(__MODULE__, :normal)
  end

  @impl true
  def init(_init_arg) do
    children =
      for n <- 1..3000 do #FIX ME value from config
        Supervisor.child_spec(
          {GeneratorSrv, %{id: n, n: :n}},
          id: "child_#{n}"
        )
      end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
