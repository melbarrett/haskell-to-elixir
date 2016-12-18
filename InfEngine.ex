defmodule InfEngine do

  import List
  import Enum

  #If &1 matches x in [{x,y}], returns y
  #Call by InfEngine.rSection("x", [{"x", "y"}])
  #Recurses and checks all tuples in &2[{}]
  def rSection(x, []), do: []
  def rSection(x, [head | tail]) do
    {z, y} = head
    if x == z do Enum.sort(Enum.concat(rSection(x, tail), [y])) else rSection(x, tail) end
  end

  #if head tuple of list on right has a first element that
  #matches the second element of the head tuple in the second list
  #add that element from the first list to the output
  #Call: InfEngine.<~>([{"x", "y"}], [{"y", "x"}, {"x", "z"}])
  def []<~>[], do: []
  def []<~>_, do: []
  def _<~>[], do: []
  def [r|rs]<~>[s|ss] do
    {x, y} = r
    {w, z} = s
    if y == w do Enum.concat((rs<~>ss),[{x, z}])
    else rs<~>ss end
  end

  #Helper function to pass as argument
  #Elixir doesn't let you recurse with anonymous functions
  def rtcH(i, [head|tail]) do
    Enum.sort(Enum.uniq(Enum.concat(i, [head|tail]<~>i)))
  end
  #Reflexive transitive closure
  #If x matches z in {y,z}, it adds {x,x} to list
  #Call InfEngine.rtc("b", [{"a", "b"}])
  def rtc(x, [head|tail]) do
    i = [{x,x}]
    lfp(&InfEngine.rtcH/2, i, [head|tail])
  end
  #Passed rtcH of arity 2, it takes 2 arguments
  #If {x,x} == list returned by [h|t]<~>i, it returns {x,x}
  #Else, it recurses on itself with rtcH returned
  def lfp(f, i, [head|tail]) do
    if i == f.(i, [head|tail]) do f.(i, [head|tail])
    else lfp(&InfEngine.rtcH/2, f.(i, [head|tail]), [head|tail]) end
  end

  #Class structure, keywords for its class, and oppclass
  defmodule Class do
    defstruct [:class, :oppclass]
  end

  #Predefined classes a & b for brevity when calling functions
  def a do
    a = %Class{class: "a", oppclass: "non-a"}
  end
  def b do
    b = %Class{class: "b", oppclass: "non-b"}
  end

  #returns the oppclass key of a class
  def opp(class) do
    class.oppclass
  end

  #knowledge base struct
  #keywords for class1, class2, and a boolean value
  #if b = true, c1 is a subset of c2, not c2 is a subset of not c1, etc.
  defmodule KB do
    defstruct [:c1, :c2, :b]
  end

  #Predefined knowledge base abT & abF for brevity when calling functions
  def abT do
    abT = %KB{c1: a, c2: b, b: true}
  end
  def abF do
    abf = %KB{c1: a, c2: b, b: false}
  end

  #Statement struct with keywords for question, class1, class2
  #All a b = all a are b
  defmodule Statement do
    defstruct [:q, :c1, :c2]
  end

  #Predefined statement for brevity
  #question, areall A's B's?
  def areA do
    areA = %Statement{q: :areAll, c1: a, c2: b}
  end

  #Checks if a statement is a question
  #Call InfEngine.isQuery(InfEngine.areA)
  def isQuery(s) do
    s.q == :areAll or s.q == :areNo or s.q == :areAny or
    s.q == :anyNot or s.q == :what
  end

  #Negates that q key of a statement
  def neg(sq) do
    if sq == :areAll do sq = :anyNot end
    if sq == :areNo do sq = :areAny end
    if sq == :areAny do sq = :areNo end
    if sq == :anyNot do sq = :areAll end
  end

  #returns a list of class tuples [{class, class}]
  #Call InfEngine.subSetRel(InfEngine.abT) or InfEngine.subSetRel(InfEngine.abF)
  #Finds the subset relations base on T/F value of KB
  #So if A is a subset of B, it returns all of the relations
  #between classes that are true given that.
  #If A is not a subset of B, it returns a list of identities for both classes.
  def subSetRel(kb) do
    i = [{kb.c1.class, kb.c2.class}]
    j = [{kb.c1.oppclass, kb.c2.oppclass}]
    [k|ks]= (Enum.uniq(rtc(domain(kb), i)))
    ks = Tuple.to_list(k)
    ks = delete_at(ks, 0)
    Enum.fetch!(ks, 0)
  end

  #Computes a list of facts about the classes passed to it and Their
  #subset relations based on TF value
  def domain(kb) do
    Enum.sort(Enum.uniq(dom([kb.c1, kb.c2, kb.b])))
  end

  #Helper function
  def dom([]), do: []
  def dom([c1, c2, b]) do
    if b do [{c1.class, c2.class}] ++ [{c2.oppclass, c1.oppclass}]
    ++ [{c1.class, c1.class}] ++ [{c2.class, c2.class}]
    ++ [{c1.oppclass, c1.oppclass}] ++ [{c2.oppclass, c2.oppclass}]
    else [{c1.class, c1.class}] ++ [{c2.class, c2.class}]
    ++ [{c1.oppclass, c1.oppclass}] ++ [{c2.oppclass, c2.oppclass}] end
  end

  #Returns a list of classes that are the supersets of the classes returned by
  #subset rel.
  #If A is a subset of B, we know that A is a superset of A & B
  #We also know that B is a superset of B, but it isn't for A
  #Call: InfEngine.supersets(InfEngine.a, InfEngine.abT)
  def supersets(cl, kb) do
    rSection(cl.class, subSetRel(kb))
  end

  #Returns the list of relations that are not subsets of each other.
  #Call: InfEngine.nsubSetRel(InfEngine.abT)
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

  #Returns list of classes that are not supersets of the
  #classes returned by nsubsetrel
  #Call InfEngine.nsupersets(InfEngine.b, InfEngine.abT)
  def nsupersets(cl, kb) do
   rSection(cl.class, nsubSetRel(kb))
  end

  #returns a boolean if class2 in statment is in the list of
  #classes returned by checking class1 in statement is a superset of the kb.
  #Call: InfEngine.derive(InfEngine.abT, InfEngine.areA) 
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
