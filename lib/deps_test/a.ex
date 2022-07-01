defmodule DepsTest.A do
  def moo, do: DepsTest.B.moo()
end
