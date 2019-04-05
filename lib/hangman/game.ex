defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initialising,
    letters: [],
    used: MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{letters: word |> String.codepoints()}
  end

  def new_game() do
    Dictionary.random_word() |> new_game()
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
    |> score_guess(Enum.member?(game.letters, guess))
  end

  def score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won

    Map.put(game, :game_state, new_state)
  end

  def score_guess(game, _not_good_guess) do
    # %Hangman.Game{
    #   turns_left: game.turns_left - 1,
    #   game_state: :bad_move,
    #   letters: game.letters,
    #   used: game.used
    # }
    game
  end

  def maybe_won(true), do: :won
  def maybe_won(_), do: :good_guess

  def tully(_) do
    123
  end
end
