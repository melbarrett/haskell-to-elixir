defmodule FSemF do
  import List
  import Enum
  import FSynF

  #Example grid for testing.
  def exampleGrid do
    [{A, 9},
    {B, 4}, {B, 5}, {B, 6}, {B, 7}, {B, 9},
    {C, 9}, {D,4}, {E, 4}, {F, 4},
    {G, 4}, {G, 7}, {G, 8}, {G, 9},
    {H, 1}, {H, 4}, {I,1}]
  end

  #List of attacks make
  def attacks do
    [{F, 9}, {E, 8}, {D, 7}, {C, 6}]
  end

  #Ships, where they are on grid
  def battleship do
    %FSynF.Ship{ship: [{D, 4}, {E, 4}, {F, 4}, {G, 4}, {H, 4}]}
  end
  def frigate do
    %FSynF.Ship{ship: [{B, 4}, {B,5}, {B,6}, {B,7}]}
  end
  def sub1 do
    %FSynF.Ship{ship: [{A,9},{B, 9},{C,9}]}
  end
  def sub2 do
    %FSynF.Ship{ship: [{G,7}, {G,8}, {G,9}]}
  end
  def destroyer do
    %FSynF.Ship{ship: [{H,1}, {I,1}]}
  end

  #Distribution of ships on board
  def shipDistrib do
    [battleship.ship, frigate.ship, sub1.ship, sub2.ship, destroyer.ship]
  end
  #State for testng
  def exampleState do
    {shipDistrib, attacks}
  end

  #Checks for ship clashes
  def nodups([]), do: true
  def nodups([x|xs]) do
    !(x in xs) and nodups(xs)
  end
  def noClashes({dist, _}) do
    nodups(Enum.concat(dist))
  end

  #Checks if there is a ship in attack spot
  def hit(attack, {gs,_}) do
    {attack.column, attack.row} in Enum.concat(gs)
  end
  #Returns true if hit returns false
  def missed(attack, {gs,g}) do
    !(hit(attack, {gs,g}))
  end
  #If all ship spots are in attacks, then the game is over
  def defeated({gs, g}) do
    gs = Enum.concat(gs)
    Enum.all?(g, fn gs -> Enum.member?(gs,g) end)
  end
  #Updated grid
  def updateBattle(attack, {gs, g}) do
    Enum.concat([{attack.column, attack.row}], g)
  end

  #Redid form structure
  #Kept getting stuck trying to use one implemented in FSynF.ex
  defmodule FormS do
    defstruct [:expression]
  end
  defmodule P do
    defstruct [:name]
  end
  defmodule Ng do
    defstruct [:ng]
  end
  defmodule Cnj do
    defstruct [:cnj]
  end
  defmodule Dsj do
    defstruct [:dsj]
  end

  #P's for testing
  def p1 do
    p1 = %P{name: "P"}
  end
  def q1 do
    q1 = %P{name: "Q"}
  end

  #Forms for testing
  def form0 do
    form0 = %FormS{expression: %Cnj{cnj: [%P{name: "P"}, %P{name: "Q"}]}}
  end
  def form1 do
    form1 = %FormS{expression: %Cnj{cnj: [%P{name: "P"}, %Ng{ng: %P{name: "P"}}]}}
  end
  def form2 do
    form2 = %FormS{expression: %Dsj{dsj:
      [%P{name: "p1"}, %P{name: "p2"}, %P{name: "p3"}, %P{name: "p4"}]}}
  end
end
