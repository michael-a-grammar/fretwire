defmodule Fretwire.ScaleIntervals do
  @moduledoc false

  import Fretwire.Interval.Sigils

  def chromatic do
    [
      ~INTERVAL/P1/,
      ~INTERVAL/m2/,
      ~INTERVAL/M2/,
      ~INTERVAL/m3/,
      ~INTERVAL/M3/,
      ~INTERVAL/P4/,
      ~INTERVAL/a4/,
      ~INTERVAL/P5/,
      ~INTERVAL/m6/,
      ~INTERVAL/M6/,
      ~INTERVAL/m7/,
      ~INTERVAL/M7/,
      ~INTERVAL/P8/
    ]
  end

  def minor_pentatonic do
    [
      ~INTERVAL/P1/,
      ~INTERVAL/m3/,
      ~INTERVAL/P4/,
      ~INTERVAL/P5/,
      ~INTERVAL/m7/,
      ~INTERVAL/P8/
    ]
  end
end
