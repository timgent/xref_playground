defmodule DepsTest.A do
  def moo, do: DepsTest.B.moo()

  # Dependencies are done at a module level, so even though DepsTest is only dependent on the quack function,
  # it just counts as a dependency on the DepsTest.A module. This then means all runtime dependencies of DepsTest.A 
  # also become compile time dependencies of DepsTest
  def quack, do: "quack"
end
