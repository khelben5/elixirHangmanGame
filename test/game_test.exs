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
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()

    game = Game.make_move(game, "a")

    assert game.game_state != :already_used
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game()

    game = Game.make_move(game, "a")
    game = Game.make_move(game, "a")

    assert game.game_state == :already_used
  end

  test "a good guess is recognised" do
    game = Game.new_game("hello")

    game = Game.make_move(game, "h")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is won game" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    Game.new_game("wibble") |> assert_moves_are_expected(moves)
  end

  test "a bad move decrements turns left" do
    game = Game.new_game("hello")

    new_game = Game.make_move(game, "a")

    assert new_game.turns_left == game.turns_left - 1
  end

  test "a bad move returns bad guess" do
    game = Game.new_game("hello")

    game = Game.make_move(game, "a")

    assert game.game_state == :bad_guess
  end

  test "can lose the game" do
    moves = [
      {"a", :bad_guess},
      {"b", :bad_guess},
      {"c", :bad_guess},
      {"d", :bad_guess},
      {"e", :bad_guess},
      {"f", :bad_guess},
      {"g", :lost}
    ]

    Game.new_game("x") |> assert_moves_are_expected(moves)
  end

  def assert_moves_are_expected(game, moves) do
    Enum.reduce(
      moves,
      game,
      fn {guess, expected_state}, acc ->
        new_game = Game.make_move(acc, guess)
        assert new_game.game_state == expected_state
        new_game
      end
    )
  end
end
