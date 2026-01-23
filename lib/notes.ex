defmodule Fret.Notes do
  @moduledoc false

  use Fret.Note.Elements

  import Fret.Note

  alias Fret.Note

  # The frequency of A4 in hertz
  @reference_note_frequency 440

  @type query :: %{
          name: Note.note_name(),
          accidental: Note.accidental(),
          octave: Note.octave()
        }

  @type notes :: nonempty_list(Note.note())

  defguard is_query(query)
           when is_map(query) and
                  query.name in @note_names and
                  query.accidental in @accidentals and
                  query.octave in @octaves

  @spec find(query()) :: Note.note()
  def find(query) when is_query(query), do: Enum.find(get(), &query_matches_note?(query, &1))

  @spec slice(from :: query(), to :: integer() | nil) :: notes()
  def slice(from, to) when is_query(from) and is_integer(to) do
    get()
    |> then(fn notes ->
      notes
      |> Enum.find_index(&query_matches_note?(from, &1))
      |> then(&Enum.slice(notes, &1, to))
    end)
  end

  @spec compare(query1 :: query(), query2 :: query()) :: :lt | :eq | :gt
  def compare(query1, query2) do
    [frequency1, frequency2] =
      [query1, query2]
      |> Enum.map(&find/1)
      |> Enum.map(fn
        %Note{
          frequency: frequency
        } ->
          frequency

        {%Note{
           frequency: frequency
         }, _} ->
          frequency
      end)

    cond do
      frequency1 < frequency2 ->
        :lt

      frequency1 == frequency2 ->
        :eq

      frequency1 > frequency2 ->
        :gt
    end
  end

  defp get do
    @octaves
    |> Enum.flat_map(fn octave ->
      @note_names
      |> Enum.map(&{&1, octave})
      |> Enum.chunk_every(2, 1)
      |> Enum.flat_map(fn
        [{:e, _} = e, {:f, _}] ->
          [e]

        [{name, octave}, {next_name, _}] ->
          [{name, octave}, {name, next_name, octave}]

        b ->
          b
      end)
      |> Enum.filter(fn
        {name, 0} when name not in [:a, :b] ->
          false

        {name, _, 0} when name not in [:a, :b] ->
          false

        {name, 8} when name != :c ->
          false

        {_, _, 8} ->
          false

        _ ->
          true
      end)
    end)
    |> then(fn notes ->
      reference_note_index = Enum.find_index(notes, &match?({:a, 4}, &1)) + 1

      notes
      |> Enum.with_index(1)
      |> Enum.map(fn
        {note, index} ->
          semitones_away_from_reference_note = index - reference_note_index

          frequency =
            Float.round(
              2 ** (semitones_away_from_reference_note / 12) * @reference_note_frequency,
              2
            )

          case note do
            {name, octave} ->
              {name, octave, frequency}

            {name, other_name, octave} ->
              {name, other_name, octave, frequency}
          end
      end)
    end)
    |> Enum.map(&new/1)
  end

  defp query_matches_note?(
         %{
           name: name,
           accidental: accidental,
           octave: octave
         },
         %Note{
           name: name,
           accidental: accidental,
           octave: octave
         }
       ) do
    true
  end

  defp query_matches_note?(query, {sharp_note, flat_note}) do
    query_matches_note?(query, sharp_note) or query_matches_note?(query, flat_note)
  end

  defp query_matches_note?(_, _) do
    false
  end
end
