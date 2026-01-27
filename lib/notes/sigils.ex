defmodule Fretwire.Notes.Sigils do
  @moduledoc false

  use Fretwire.Note.Elements

  alias Fretwire.Notes.Query

  def sigil_NOTE(string, []) do
    with %{"name" => note_name, "accidental" => accidental, "octave" => octave} <-
           Regex.named_captures(
             ~r/^(?<name>[a-gA-G]{1,1})(?<accidental>#|b|)(?<octave>[0-8]{1,1})$/,
             string
           ),
         {:ok, accidental} <- parse_accidental(accidental),
         {:ok, note_name} <- parse_note_name(note_name, accidental),
         {:ok, octave} <- parse_octave(octave) do
      %Query{
        note_name: note_name,
        accidental: accidental,
        octave: octave
      }
    else
      nil ->
        {:error, "can not parse note"}

      error ->
        error
    end
  end

  defp parse_accidental(accidental) do
    accidental
    |> String.downcase()
    |> case do
      "" ->
        :natural

      "#" ->
        :sharp

      "b" ->
        :flat
    end
    |> then(&{:ok, &1})
  end

  defp parse_note_name(note_name, accidental) do
    note_name
    |> String.downcase()
    |> then(fn note_name ->
      try do
        String.to_existing_atom(note_name)
      rescue
        _ in ArgumentError ->
          {:error, "can not parse note name"}
      end
    end)
    |> then(fn note_name ->
      cond do
        accidental == :natural and note_name in @note_names ->
          {:ok, note_name}

        accidental == :sharp and note_name in @sharp_note_names ->
          {:ok, note_name}

        accidental == :flat and note_name in @flat_note_names ->
          {:ok, note_name}

        true ->
          {:error, "can not parse note name"}
      end
    end)
  end

  defp parse_octave(octave) do
    octave
    |> Integer.parse()
    |> then(&{:ok, elem(&1, 0)})
  end
end
