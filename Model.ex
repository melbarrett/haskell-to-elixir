defmodule Model do
#Model module.
#Call functions by using Model.fn(args)
#Entities can be passed as either atoms or their declared names
#into functions. Either alice of :A

  #entity structure
  defmodule Entity do
    defstruct [:entity]
  end

  #Declaring entities.
  def snowWhite do
    snowWhite = %Entity{entity: :S}
  end
  def alice do
    alice = %Entity{entity: :A}
  end
  def dorothy do
    dorothy = %Entity{entity: :D}
  end
  def goldilocks do
    goldilocks = %Entity{entity: :G}
  end
  def littleMook do
    littleMook = %Entity{entity: :M}
  end
  def atreyu do
    atreyu = %Entity{entity: :Y}
  end

  #suite of first place predicate functions
  #Checks if x is in the list, or if x is an atom,
  #it checks if the heads entity atom matches
  def l2opp([], x) do
    false
  end
  def l2opp([head | tail], x) do
    if head.entity == x do true else l2opp(tail, x) end
  end
  def list2OnePlacePred(xs,x) do
    if is_atom(x) do l2opp(xs,x)
    else if Enum.member?(xs, x) do true else false end end
  end

  #Grouping entities
  def girl(x), do:
    girl = list2OnePlacePred([snowWhite, alice, dorothy, goldilocks], x)
  def boy(x), do: boy = list2OnePlacePred([littleMook, atreyu], x)
  def princess(x), do:
    princess = list2OnePlacePred([%Entity{entity: :E}], x)
  def dwarf(x), do:
    list2OnePlacePred([%Entity{entity: :B}, %Entity{entity: :R}], x)
  def giant(x), do:
    list2OnePlacePred([%Entity{entity: :T}], x)
  def wizard(x), do:
    list2OnePlacePred([%Entity{entity: :W}, %Entity{entity: :V}], x)
  def sword(x), do:
    list2OnePlacePred([%Entity{entity: :F}], x)
  def dagger(x), do:
    list2OnePlacePred([%Entity{entity: :X}], x)

  #Defining groups of entities
  def child(x), do: child = girl(x) or boy(x)
  def person(x), do: person = child(x) or princess(x) or dwarf(x)
                      or giant(x) or wizard(x)
  def man(x), do: man = dwarf(x) or giant(x) or wizard(x)
  def woman(x), do: woman = princess(x)
  def male(x), do: male = man(x) or boy(x)
  def female(x), do: woman(x) or girl(x)
  def thing(x), do: !person(x)

  #first place predicates
  #x laughs
  #Call "Model.laugh(Model.alice)" or "Model.laugh(:A)"
  def laugh(x), do:
    list2OnePlacePred([alice, goldilocks, %Entity{entity: :E}], x)
  def cheer(x), do:
    list2OnePlacePred([littleMook, dorothy], x)
  def shudder(x), do:
    list2OnePlacePred([snowWhite], x)

  #Suite of functions for 2placepred
  #Checks is {x,y} are in the list of entities,
  #Or if an atom was passed it checks if the entities atom matches
  def l2tpp([], x, y) do
    false
  end
  def l2tpp([head | tail], x, y) do
    [h|t] = Tuple.to_list(head)
    [t|_] = t
    if (h.entity == x or h == x) and (t.entity == y or t == y)
     do true else l2tpp(tail, x, y) end
  end
  def list2TwoPlacePred(xs, x, y) do
    if is_atom(x) or is_atom(y) do l2tpp(xs, x, y)
    else if Enum.member?(xs, {x,y}) do true else false end end
  end

  #Second place predicates
  #Call "Model.love(x,y)", x loves y
  #Can use Model.snowWhite or :S for all declared entities
  def love(x,y) do
    list2TwoPlacePred([{atreyu, %Entity{entity: :E}},
    {%Entity{entity: :B}, snowWhite},
    {%Entity{entity: :R}, snowWhite}], x, y)
  end
  def admire(x,y) do
    if person(x) == true do
    list2TwoPlacePred([{%Entity{entity: x}, goldilocks}], x, y) else false end
  end
  def help(x,y) do
    list2TwoPlacePred([{%Entity{entity: :W}, %Entity{entity: :W}},
    {%Entity{entity: :V}, %Entity{entity: :V}},
    {snowWhite, %Entity{entity: :B}},
    {dorothy, littleMook}], x, y)
  end
  def defeat(x, y) do
    if dwarf(x) and giant(y) == true do
      list2TwoPlacePred([{%Entity{entity: x}, %Entity{entity: y}}], x, y)
    else list2TwoPlacePred([{alice, %Entity{entity: :W}},
          {alice, %Entity{entity: :V}}], x, y) end
  end

  #Suite of functions to deal with 3placepred
  #Checks if {x,y,z} is in the list,
  #or if any of them are atoms, it goes to helper
  def l2thpp([], x, y, z) do
    false
  end
  def l2thpp([head | tail], x, y, z) do
    [h|t] = Tuple.to_list(head)
    [t|tt] = t
    [tt|_] = tt
    if (h.entity == x or h == x) and (t.entity == y or t == y)
      and (tt.entity == z or tt == z)
     do true else l2thpp(tail, x, y, z) end
  end
  def list2ThreePlacePred(xs, x, y, z) do
    if is_atom(x) or is_atom(y) or is_atom(z) do l2thpp(xs, x, y, z)
    else if Enum.member?(xs, {x,y,z}) do true else false end end
  end

  #Third place predicates give and kill
  #Call "Model.give(x, y, z)"
  #Where x,y,z can be a declared entity or atom ie. :S, Model.snowWhite, :Y
  def give(x, y, z) do
    list2ThreePlacePred([{%Entity{entity: :T}, snowWhite, %Entity{entity: :X}},
    {alice, %Entity{entity: :E}, snowWhite}] , x, y, z)
  end
  def kill(x, y, z) do
    list2ThreePlacePred([{atreyu, %Entity{entity: :T}, %Entity{entity: :F}},
    {%Entity{entity: :unspec}, dorothy, %Entity{entity: :X}},
    {%Entity{entity: :unspec}, littleMook, %Entity{entity: :unspec}}], x,y,z)
  end

  #Instead of x verbs y, passivize is x verbs
  #Same as calling "Model.admire(:G, :unspec)"
  #Call "Model.passivize(&Model.admire/2, :G)"
  #Goldilocks admires
  def passivize(f, x) do
    f.(x, :unspec)
  end

  #Reflexive self
  #Goldilocks admires herself
  #Same as calling "Model.admire(:G, :G)"
  def self(f, x) do
    f.(x,x)
  end

end
