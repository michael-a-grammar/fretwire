defmodule Fret.Note.Elements do
  @moduledoc false

  @note_names [:c, :d, :e, :f, :g, :a, :b]

  @natural_note_names @note_names

  @sharp_note_names [:f, :c, :g, :d, :a]

  @flat_note_names [:b, :e, :a, :d, :g]

  @accidentals [:natural, :sharp, :flat]

  @octaves 0..8

  @type note_name :: :c | :d | :e | :f | :g | :a | :b

  @type sharp_note_name :: :f | :c | :g | :d | :a

  @type flat_note_name :: :b | :e | :a | :d | :g

  @type accidental :: :natural | :sharp | :flat

  @type octave :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

  @type frequency :: float()

  defmacro __using__(_) do
    quote bind_quoted: [
            note_names: @note_names,
            natural_note_names: @natural_note_names,
            sharp_note_names: @sharp_note_names,
            flat_note_names: @flat_note_names,
            accidentals: @accidentals,
            octaves: Macro.escape(@octaves)
          ] do
      @note_names note_names

      @natural_note_names natural_note_names

      @sharp_note_names sharp_note_names

      @flat_note_names flat_note_names

      @accidentals accidentals

      @octaves octaves
    end
  end
end
