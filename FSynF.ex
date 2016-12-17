defmodule FSynF do
  import List

  #Attack Struct with keys for column, row
  defmodule Attack do
    defstruct [:column, :row]
  end

  #Turn struct with Attack, Reaction keys
  defmodule Turn do
    defstruct [:attack, :reaction]
  end

  #Ship struct with ship key
  defmodule Ship do
    defstruct [:ship]
  end

  #Reaction struct with verb, ship keys
  defmodule Reaction do
    defstruct [:verb, :ship]
  end

  #Pattern struct
  defmodule Pattern do
    defstruct [:colour]
  end

  #answer struct
  defmodule Answer do
    defstruct [:feedback]
  end

  #Sentence struct, keys for noun phrase, verb phrase
  defmodule Sentence do
    defstruct [:np, :vp]
  end

  #noun phrase struct, keys for determiner, common noun
  #or determine, relative clause noun
  defmodule NP do
    defstruct [:det, :cn, :rcn]
  end

  #Relative clause noun struct, keys for noun that verbs,
  #noun that noun verbed or adjective noun
  defmodule RCN do
    defstruct [:cn, :that, :vp, :np, :tv, :adj, :cn, :det, :dv]
  end

  #verb phrase struct, keys for transitive-verb noun,
  #noun ditranstive-verb noun, or attitude-verb to infinitive
  defmodule VP do
    defstruct [:tv, :dv, :np, :np1, :av, :to, :inf]
  end

  #infinitive struct with keys for trasitive infinitive, noun
  defmodule INF do
    defstruct [:tinf, :np]
  end

  #Defines form struct
  defmodule Form do
    defstruct p: "p", ng: "-", cnj: "&[", dsj: "v["
  end

  #Defines forms
  def form1 do
    form1 = %Form{}
    IO.inspect(form1.cnj <> form1.p <> ", " <> form1.ng <> form1.p <> "]")
  end

  def form2 do
    form2 = %Form{}
    IO.inspect(form2.dsj <> form2.p <> "1, " <> form2.p <> "2, " <> form2.p <> "3, " <> form2.p <> "4]")
  end

  #Variable struct
  defmodule Variable do
    defstruct [:name, :index]
  end

  #Formula struct
  defmodule Formula do
    defstruct atom: nil, eq: "==", neg: "~", forall: "A ", impl: "==>",
              equi: "<==>", conj: "conj", disj: "disj", every: "E "
  end

  #Defines formulas
  #Call by FSynF.formula0
  def formula0 do
    x = %Variable{name: "x"}
    y = %Variable{name: "y"}
    formula0 = %Formula{atom: "R"}
    IO.puts [formula0.atom, "[", x.name, ",", y.name, "]"]
  end
  def formula1 do
    x = %Variable{name: "x"}
    y = %Variable{name: "y"}
    formula1 = %Formula{atom: "R"}
    IO.puts [formula1.forall, x.name, " ", formula1.atom,
            "[", x.name, ",", y.name, "]"]
  end
  def formula2 do
    x = %Variable{name: "x"}
    y = %Variable{name: "y"}
    formula2 = %Formula{atom: "R"}
    IO.puts [formula2.forall, x.name, " ", formula2.forall, y.name, " ",
            "(", formula2.atom, "[", x.name, ",", y.name, "]", formula2.impl,
            formula2.atom, "[", y.name, ",", x.name, "])"]
  end

  #Term struct
  defmodule Term do
    defstruct [:var]
  end

  #Defines Variables
  def tx do
    tx = %Term{var: %Variable{name: "x"}}
  end
  def ty do
    ty = %Term{var: %Variable{name: "y"}}
  end
  def tz do
    tz = %Term{var: %Variable{name: "z"}}
  end

  #Checks if a term is a var
  #Call FSynF.isVar(FSynF.tx)
  def isVar(x) do
    if(x.var.name != nil) do true else false end
  end

  #Returns the variable in Term
  def varsInTerm(x) do
    x.var.name
  end
  #Returns the unique variables from a list of terms
  def varsInTerms(x) do
      Enum.uniq(Enum.map(x, &FSynF.varsInTerm/1))
  end


end
