defmodule Fretwire.Interval.Sigils do
  @moduledoc false

  alias Fretwire.Interval

  def sigil_INTERVAL(string, []) do
    with %{"quality" => quality, "number" => interval_number} <-
           Regex.named_captures(
             ~r/^(?<quality>P|m|M|d|A)(?<number>[0-8]{1,1})/,
             string
           ),
         {:ok, quality} <- parse_quality(quality),
         {:ok, interval_number} <- parse_interval_number(interval_number) do
      Interval.new(quality, interval_number)
    else
      nil ->
        {:error, "can not parse interval"}

      error ->
        error
    end
  end

  defp parse_quality(quality) do
    case quality do
      "P" ->
        :perfect

      "m" ->
        :minor

      "M" ->
        :major

      "d" ->
        :diminished

      "A" ->
        :augmented
    end
    |> then(&{:ok, &1})
  end

  defp parse_interval_number(interval_number) do
    interval_number
    |> Integer.parse()
    |> then(&{:ok, elem(&1, 0)})
  end
end
