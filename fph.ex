import String

#Fph module, Elixir version of original Haskell code from
#"Computational Semantics with Functional Programming"
#By Jan van Eijck & Christina Unger
#http://www.computational-semantics.eu/FPH.hs
# Converted from Haskell into Elixir by Melissa Barrett

#Compile by running: elixirc fph.ex
#Then go into iex, run: Fph.square(4), Fph.hword("hello"), etc.
defmodule Fph do

  #Takes in an int, multiplies by itself, returns.
  def square(x) do
    x * x
  end

  #Takes in a string, checks if it contains letter h, returns true or false.
  def hword(str) do
    if contains?(str, "h") do true else false end
  end

  #Takes in an int, recursively generates a string based on int passed.
  def gen(n) when n == 0 do
    "Sentences can go on"
  end
  def gen(n) do
    gen(n - 1) <> " and on"
  end

  #Adds a period to the sentence generated above.
  def genS(n) do
    gen(n) <> "."
  end

  #Takes in an int
  #Generates a set of sentences n times, before finishing with a final sentence.
  def story(k) when k == 0 do
    IO.puts("Let's cook and eat that final missionary, and off to bed.")
  end
  def story(k) do
    IO.puts("'The night was pitch dark, mysterious and deep.\n"
    <> "Ten cannibals were seated around a boiling cauldron.\n"
    <> "Their leader got up and addressed them like this:'\n")
    story(k-1)
  end

  #takes a string
  #Reverses the graphemes in a string
  #Uses the elixir string library function
  def reversal(x) do
    reverse(x)
  end

  def sonnet18 do
    IO.puts("Shall I compare thee to a summer's day? \n"
    <> "Thou art more lovely and more temperate: \n"
    <> "Rough winds do shake the darling buds of May, \n"
    <> "And summer's lease hath all too short a date: \n"
    <> "Sometime too hot the eye of heaven shines, \n"
    <> "And often is his gold complexion dimm'd; \n"
    <> "And every fair from fair sometime declines, \n"
    <> "By chance or nature's changing course untrimm'd; \n"
    <> "But thy eternal summer shall not fade \n"
    <> "Nor lose possession of that fair thou owest; \n"
    <> "Nor shall Death brag thou wander'st in his shade, \n"
    <> "When in eternal lines to time thou growest: \n"
    <> "  So long as men can breathe or eyes can see, \n"
    <> "  So long lives this and this gives life to thee.")
  end

  def sonnet73 do
    IO.puts("That time of year thou mayst in me behold\n"
    <> "When yellow leaves, or none, or few, do hang\n"
    <> "Upon those boughs which shake against the cold,\n"
    <> "Bare ruin'd choirs, where late the sweet birds sang.\n"
    <> "In me thou seest the twilight of such day\n"
    <> "As after sunset fadeth in the west,\n"
    <> "Which by and by black night doth take away,\n"
    <> "Death's second self, that seals up all in rest.\n"
    <> "In me thou see'st the glowing of such fire\n"
    <> "That on the ashes of his youth doth lie,\n"
    <> "As the death-bed whereon it must expire\n"
    <> "Consumed with that which it was nourish'd by.\n"
    <> "This thou perceivest, which makes thy love more strong,\n"
    <> "To love that well which thou must leave ere long.")
  end

  #Recursive function that counts the instances of x in a list of Ints
  def count(x, []) do
    0
  end
  def count(x, [head | tail]) when x == head do
    count(x, tail) + 1
  end
  def count(x, [head | tail]) do
    count(x, tail)
  end

  #takes in a list of integers
  #returns the average of elements in list
  def average([]) do
    raise "empty list"
  end
  def average([head | tail]) do
    sum_list([head | tail], 0) / Kernel.length([head | tail])
  end

  #helper function to figure out the sum of a list of integers
  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end
  def sum_list([], accumulator) do
    accumulator
  end


end
