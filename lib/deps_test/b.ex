defmodule DepsTest.B do
  def moo, do: DepsTest.C.moo()
end
