defmodule InfEngine do

  import List
  import Enum

  def rSection(x, []), do: []
  def rSection(x, [head | tail]) do
    {z, y} = head
    if x == z do Enum.sort(Enum.concat(rSection(x, tail), [y])) else rSection(x, tail) end
  end

  def []<~>[], do: []
  def []<~>_, do: []
  def _<~>[], do: []
  def [r|rs]<~>[s|ss] do
    {x, y} = r
    {w, z} = s
    if y == w do Enum.concat((rs<~>ss),[{x, z}])
    else rs<~>ss end
  end

  def rtcH(i, [head|tail]) do
    Enum.sort(Enum.uniq(Enum.concat(i, [head|tail]<~>i)))
  end
  def rtc(x, [head|tail]) do
    i = [{x,x}]
    lfp(&InfEngine.rtcH/2, i, [head|tail])
  end
  def lfp(f, i, [head|tail]) do
    if i == f.(i, [head|tail]) do f.(i, [head|tail])
    else lfp(&InfEngine.rtcH/2, f.(i, [head|tail]), [head|tail]) end
  end

  defmodule Class do
    defstruct [:class, :oppclass]
  end

  def opp(class) do
    class.oppclass
  end

  
end
