defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.splitter("\n", trim: true)
  end

  @doc """
  Calculates guard ID multiplied by minute. Strategy is to find the guard that has the most
  minutes asslep with minute spend asleep the most.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    72925
  """
  def calc_part_1(input) do
    input
    |> Enum.map(&parse_line(&1))
    |> sort_chronologically()
    |> cummulate_guard_activities()
    |> Enum.map(&format_guard_data(&1))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(&calculate_minutes_asleep(&1))
    |> Enum.max_by(&elem(&1, 1))
    |> calculate_most_asleep_minute()
    |> calculate_result()
  end

  defp parse_line(line) do
    ["[", y1, y2, y3, y4, "-", m1, m2, "-", d1, d2, " ", h1, h2, ":", mi1, mi2, "]", " " | text] =
      String.graphemes(line)

    year = [y1, y2, y3, y4] |> Enum.join("") |> String.to_integer()
    month = [m1, m2] |> Enum.join("") |> String.to_integer()
    day = [d1, d2] |> Enum.join("") |> String.to_integer()
    hour = [h1, h2] |> Enum.join("") |> String.to_integer()
    minute = [mi1, mi2] |> Enum.join("") |> String.to_integer()

    %{year: year, month: month, day: day, hour: hour, minute: minute, text: text |> Enum.join("")}
  end

  defp sort_chronologically(data) do
    Enum.sort_by(data, fn %{year: year, month: month, day: day, hour: hour, minute: minute} ->
      {year, month, day, hour, minute}
    end)
  end

  defp cummulate_guard_activities(data) do
    Enum.reduce(data, [], fn
      %{text: "Guard #" <> id_and_text} = data, acc ->
        [id | _text] = String.split(id_and_text, " ")
        new_guard = {id, [data]}
        [new_guard | acc]

      %{text: _} = new_data, [last_guard | acc] ->
        {id, data} = last_guard
        [{id, [new_data | data]} | acc]
    end)
  end

  defp format_guard_data({id, activities}) do
    [_shift_begin | activities] = activities |> Enum.reverse()

    sleeps =
      activities
      |> Enum.reduce([], fn
        %{text: "falls asleep", minute: sleep_start_minute}, acc ->
          [{sleep_start_minute, nil} | acc]

        %{text: "wakes up", minute: awake_start_minute}, [{sleep_start_minute, _} | acc] ->
          [{sleep_start_minute, awake_start_minute - 1} | acc]
      end)

    {id, sleeps}
  end

  defp calculate_minutes_asleep({id, activities}) do
    sleeps = Enum.flat_map(activities, & &1)
    minutes_asleep = sleeps |> Enum.reduce(0, fn {from, to}, acc -> acc + (to - from + 1) end)

    {id, minutes_asleep, sleeps}
  end

  defp calculate_most_asleep_minute({id, _minutes_asleep, sleeps}) do
    most_asleep_minute = Enum.max_by(calculate_minute_frequency(sleeps), &elem(&1, 1))

    {id, most_asleep_minute}
  end

  defp calculate_minute_frequency(sleeps) do
    sleeps
    |> Enum.map(fn {from, to} -> Enum.to_list(from..to) end)
    |> Enum.reduce(%{}, fn minutes_list, acc ->
      Enum.reduce(minutes_list, acc, fn minute, ac ->
        Map.update(ac, minute, 1, &(&1 + 1))
      end)
    end)
  end

  defp calculate_result({id, {minute, _frequency}}) do
    String.to_integer(id) * minute
  end

  @doc """
  Calculates guard ID multiplied by minute. Strategy is to find the guard that is the most
  frequently asslep in one minute.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    49137
  """
  def calc_part_2(input) do
    input
    |> Enum.map(&parse_line(&1))
    |> sort_chronologically()
    |> cummulate_guard_activities()
    |> Enum.map(&format_guard_data(&1))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(&calculate_max_minute_asleep(&1))
    |> Enum.max_by(&(elem(&1, 1) |> elem(1)))
    |> calculate_result()
  end

  defp calculate_max_minute_asleep({id, activities}) do
    activities
    |> Enum.flat_map(& &1)
    |> calculate_minute_frequency()
    |> case do
      %{} = map when map_size(map) == 0 ->
        {id, {nil, 0}}

      minutes ->
        most_frequently_asleep_minute = Enum.max_by(minutes, &elem(&1, 1))

        {id, most_frequently_asleep_minute}
    end
  end
end
