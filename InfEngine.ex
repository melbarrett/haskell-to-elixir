defmodule InfEngine do

  import List
  import Enum
  defmodule Rel do
    defstruct [:a]
  end

  def rSection(x, r) do
    r = %Rel{a: r}
    [z,y] = r.a
    if(x == z) do [y] end
  end

  def r <~> s do
    r = %Rel{a: r}
    s = %Rel{a: s}
    [x,y] = r.a
    [w,z] = s.a
    if(y == w) do Enum.uniq([x,z]) else [] end
  end


  def rtcH(x,r) do
    Enum.uniq(Enum.concat((r<~>x),x))
  end
  def rtc([x|s], r) do
    i = {x, x}
    lfp(&InfEngine.rtcH/2, i, r)
  end
  def lfp(f, x, r) do
    if x == f.(x, r) do x else lfp(&InfEngine.rtcH/2, f.(x,r), r) end
  end

end
