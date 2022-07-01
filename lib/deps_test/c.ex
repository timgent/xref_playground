defmodule DepsTest.C do
  def moo, do: DepsTest.D.moo()
end
