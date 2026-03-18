defmodule Fretwire.Note.Elements do
  @moduledoc false

  use Fretwire.Symbols

  alias Fretwire.Symbols

  @note_names @letters

  @natural_note_names @note_names

  @sharp_note_names @sharp_letters

  @flat_note_names @flat_letters

  @notes @letters_with_accidentals

  @octaves 0..8

  @type note_name :: Symbols.letter()

  @type natural_note_name :: note_name()

  @type sharp_note_name :: Symbols.sharp_letter()

  @type flat_note_name :: Symbols.flat_letter()

  @type octave :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

  @type frequency :: float()

  defmacro __using__(_) do
    quote bind_quoted: [
            note_names: @note_names,
            natural_note_names: @natural_note_names,
            sharp_note_names: @sharp_note_names,
            flat_note_names: @flat_note_names,
            notes: @notes,
            accidentals: @accidentals,
            octaves: Macro.escape(@octaves)
          ] do
      @note_names note_names

      @natural_note_names natural_note_names

      @sharp_note_names sharp_note_names

      @flat_note_names flat_note_names

      @notes notes

      @accidentals accidentals

      @octaves octaves
    end
  end
end
