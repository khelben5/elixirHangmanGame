defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initialising,
    letters: [],
    used: MapSet.new()
  )

  def new_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _) when state in [:won, :lost] do
    {game, tully(game)}
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    {game, tully(game)}
  end

  def accept_move(game, _, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
  end

  def tully(_) do
    123
  end
end
