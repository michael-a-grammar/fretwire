defmodule Fretwire.Notes do
  @moduledoc false

  use Fretwire.Note.Elements

  import Fretwire.Notes.Query

  alias Fretwire.Note
  alias Fretwire.Notes.Query

  # The frequency of A4 in hertz.
  @reference_note_frequency 440

  @type notes :: nonempty_list(Note.note())

  @spec find(Query.t()) :: Note.note()
  def find(query) when is_query(query) do
    Enum.find(create_notes(), &query_matches_note?(query, &1))
  end

  @spec from(Query.t(), integer()) :: notes()
  def from(query, count) when is_query(query) and is_integer(count) do
    create_notes()
    |> then(fn notes ->
      notes
      |> Enum.find_index(&query_matches_note?(query, &1))
      |> then(&Enum.slice(notes, &1, count))
    end)
  end

  @spec compare(Query.t(), Query.t()) :: :lt | :eq | :gt
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

  defp create_notes do
    @octaves
    |> Enum.flat_map(fn octave ->
      @note_names
      |> Enum.map(&{&1, octave})
      |> Enum.chunk_every(2, 1)
      |> Enum.flat_map(&map_notes_and_octave/1)
      |> Enum.filter(&filter_notes/1)
    end)
    |> then(&calculate_note_frequencies/1)
    |> Enum.map(&create_note/1)
  end

  defp query_matches_note?(
         %Query{
           note_name: note_name,
           accidental: accidental,
           octave: octave
         },
         %Note{
           name: note_name,
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

  defp map_notes_and_octave([{:e, _} = e, {:f, _}]) do
    [e]
  end

  defp map_notes_and_octave([{note_name, octave}, {next_note_name, _}]) do
    [{note_name, octave}, {note_name, next_note_name, octave}]
  end

  defp map_notes_and_octave(b) do
    b
  end

  defp filter_notes({natural_note_name, 0}) when natural_note_name not in [:a, :b] do
    false
  end

  defp filter_notes({sharp_note_name, _, 0}) when sharp_note_name not in [:a, :b] do
    false
  end

  defp filter_notes({natural_note_name, 8}) when natural_note_name != :c do
    false
  end

  defp filter_notes({_, _, 8}) do
    false
  end

  defp filter_notes(_) do
    true
  end

  defp calculate_note_frequencies(notes) do
    reference_note_index = Enum.find_index(notes, &match?({:a, 4}, &1)) + 1

    notes
    |> Enum.with_index(1)
    |> Enum.map(&calculate_note_frequency(&1, reference_note_index))
  end

  defp calculate_note_frequency({note, index}, reference_note_index) do
    semitones_away_from_reference_note = index - reference_note_index

    frequency =
      Float.round(
        2 ** (semitones_away_from_reference_note / 12) * @reference_note_frequency,
        2
      )

    case note do
      {natural_note_name, octave} ->
        {natural_note_name, octave, frequency}

      {sharp_note_name, flat_note_name, octave} ->
        {sharp_note_name, flat_note_name, octave, frequency}
    end
  end

  defp create_note({note_name, octave, frequency}) do
    Note.new(note_name, octave, frequency)
  end

  defp create_note({sharp_note_name, flat_note_name, octave, frequency}) do
    Note.new(sharp_note_name, flat_note_name, octave, frequency)
  end
end
