defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initialising
    assert length(game.letters) > 0
  end

  test "new_game returns all ascii lower case letters" do
    assert Game.new_game().letters
           |> Enum.all?(&String.match?(&1, ~r/[a-z]/))
  end

  test "make_move won't change state when already :won or :lost" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()

    {game, _} = Game.make_move(game, "a")

    assert game.game_state != :already_used
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game()

    {game, _} = Game.make_move(game, "a")
    {game, _} = Game.make_move(game, "a")

    assert game.game_state == :already_used
  end
end
