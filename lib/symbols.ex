defmodule Fretwire.Symbols do
  @moduledoc false

  @letters [:c, :d, :e, :f, :g, :a, :b]

  @sharp_letters [:f, :c, :g, :d, :a]

  @flat_letters [:b, :e, :a, :d, :g]

  @accidentals [:natural, :sharp, :flat]

  @letters_with_accidentals @letters
                            |> Enum.chunk_every(2, 1)
                            |> Enum.flat_map(fn
                              [:e, :f] ->
                                [:e]

                              [letter, next_letter] ->
                                [letter, {{letter, :sharp}, {next_letter, :flat}}]

                              b ->
                                b
                            end)

  @type letter :: :c | :d | :e | :f | :g | :a | :b

  @type sharp_letter :: :f | :c | :g | :d | :a

  @type flat_letter :: :b | :e | :a | :d | :g

  @type accidental :: :natural | :sharp | :flat

  defmacro __using__(_) do
    quote bind_quoted: [
            letters: @letters,
            sharp_letters: @sharp_letters,
            flat_letters: @flat_letters,
            accidentals: @accidentals,
            letters_with_accidentals: @letters_with_accidentals
          ] do
      @letters letters

      @sharp_letters sharp_letters

      @flat_letters flat_letters

      @accidentals accidentals

      @letters_with_accidentals letters_with_accidentals
    end
  end
end
