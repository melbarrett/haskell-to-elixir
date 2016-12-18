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

  def a do
    a = %Class{class: "a", oppclass: "non-a"}
  end

  def b do
    b = %Class{class: "b", oppclass: "non-b"}
  end

  def opp(class) do
    class.oppclass
  end

  defmodule KB do
    defstruct [:c1, :c2, :b]
  end

  def abT do
    abT = %KB{c1: a, c2: b, b: true}
  end

  defmodule Statement do
    defstruct [:q, :c1, :c2]
  end

  def areA do
    areA = %Statement{q: :areAll, c1: a, c2: b}
  end

  def isQuery(s) do
    s.q == :areAll or s.q == :areNo or s.q == :areAny or
    s.q == :anyNot or s.q == :what
  end

  def neg(sq) do
    if sq == :areAll do sq = :anyNot end
    if sq == :areNo do sq = :areAny end
    if sq == :areAny do sq = :areNo end
    if sq == :anyNot do sq = :areAll end
  end

  def subSetRel(kb) do
    i = [{kb.c1.class, kb.c2.class}]
    j = [{kb.c1.oppclass, kb.c2.oppclass}]
    [k|ks]= (Enum.uniq(rtc(domain(kb), i)))
    ks = Tuple.to_list(k)
    ks = delete_at(ks, 0)
    Enum.fetch!(ks, 0)
  end

  def domain(kb) do
    Enum.sort(Enum.uniq(dom([kb.c1, kb.c2, kb.b])))
  end

  def dom([]), do: []
  def dom([c1, c2, b]) do
    if b do [{c1.class, c2.class}] ++ [{c2.oppclass, c1.oppclass}]
    ++ [{c1.class, c1.class}] ++ [{c2.class, c2.class}]
    ++ [{c1.oppclass, c1.oppclass}] ++ [{c2.oppclass, c2.oppclass}]
    else [{c1.class, c1.class}] ++ [{c2.class, c2.class}]
    ++ [{c1.oppclass, c1.oppclass}] ++ [{c2.oppclass, c2.oppclass}] end
  end

  def supersets(cl, kb) do
    rSection(cl.class, subSetRel(kb))
  end

  def nsubSetRel(kb) do
    s = subSetRel(kb)
    s = Enum.map(s, fn {a, b} -> {b, a} end)
    if !kb.b
      do r = [{kb.c1.class, kb.c2.class}] ++ [{kb.c2.oppclass, kb.c1.oppclass}]
      ++ [{kb.c1.class, kb.c1.oppclass}] ++ [{kb.c2.class, kb.c2.oppclass}]
      Enum.concat(s<~>r, r<~>s)
    else [{kb.c1.class, kb.c1.oppclass}] ++ [{kb.c1.class, kb.c2.oppclass}]
        ++ [{kb.c2.class, kb.c1.oppclass}] ++ [{kb.c2.class, kb.c2.oppclass}] end
  end

  def nsupersets(cl, kb) do
   rSection(cl.class, nsubSetRel(kb))
  end

  def derive(kb, s) do
   if (s.q == :areAll) do
     s.c2.class in supersets(s.c1, kb)
   else if s.q == :areNo do
     s.c2.oppclass in (supersets(s.c1, kb))
   else if s.q == :areAny do
     s.c2.oppclass in (nsupersets(s.c1, kb))
    else if s.q == :anyNot do
      s.c2.class in (nsupersets(s.c1, kb))
  end end end end
  end


end
