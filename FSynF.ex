defmodule FSynF do

  defmodule Attack do
    defstruct [:column, :row]
  end

  defmodule Turn do
    defstruct [:attack, :reaction]
  end

  @type ship :: atom

  defmodule Pattern do
    defstruct [:colour]
  end

  defmodule Answer do
    defstruct [:feedback]
  end

  defmodule Sentence do
    defstruct [:np, :vp]
  end

  defmodule NP do
    defstruct [:det, :cn] || [:det, :rcn]
  end

  defmodule RCN do
    defstruct [:cn, :that, :vp] || [:cn, :that, :np, :tv] || [:adj, :cn]
  end

  defmodule VP do
    defstruct [:tv, :np] || [:dv, :np, :np1] || [:av, :to, :inf]
  end

  defmodule INF do
    defstruct [:tinf, :np]
  end

  defmodule Form do
    defstruct p: "p", ng: "-", cnj: "&[", dsj: "v["
  end

  def form1 do
    form1 = %Form{}
    IO.inspect(form1.cnj <> form1.p <> ", " <> form1.ng <> form1.p <> "]")
  end

  def form2 do
    form2 = %Form{}
    IO.inspect(form2.dsj <> form2.p <> "1, " <> form2.p <> "2, " <> form2.p <> "3, " <> form2.p <> "4]")
  end

  defmodule Variable do
    defstruct [:name, :index]
  end
end
