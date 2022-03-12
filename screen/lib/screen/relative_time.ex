# Taken from https://github.com/bitwalker/timex/blob/a8f0d80ede5bfb2b31d9319ecca8066c925f1b85/lib/format/datetime/formatters/relative.ex
defmodule Screen.RelativeTime do
  @moduledoc """
  Relative time, based on Moment.js
  Uses localized strings.
  The format string should contain {relative}, which is where the phrase will be injected.
  | Range	                     | Sample Output
  ---------------------------------------------------------------------
  | 0 seconds                  | now
  | 1 to 45 seconds	           | a few seconds ago
  | 45 to 90 seconds	         | a minute ago
  | 90 seconds to 45 minutes	 | 2 minutes ago ... 45 minutes ago
  | 45 to 90 minutes	         | an hour ago
  | 90 minutes to 22 hours	   | 2 hours ago ... 22 hours ago
  | 22 to 36 hours	           | a day ago
  | 36 hours to 25 days	       | 2 days ago ... 25 days ago
  | 25 to 45 days	             | a month ago
  | 45 to 345 days	           | 2 months ago ... 11 months ago
  | 345 to 545 days (1.5 years)  | a year ago
  | 546 days+	                 | 2 years ago ... 20 years ago
  """
  @minute 60
  @hour @minute * 60
  @day @hour * 24
  @month @day * 30
  @year @month * 12

  def time_ago(datetime) do
    diff = DateTime.diff(datetime, DateTime.utc_now(), :second)
    describe(diff)
  end

  def describe(diff) do
    cond do
      # future
      diff == 0 ->
        "now"

      diff > 0 && diff <= 45 ->
        "in #{diff} sec"

      diff > 45 && diff < @minute * 2 ->
        "in 1 min"

      diff >= @minute * 2 && diff < @hour ->
        "in #{div(diff, @minute)} min"

      diff >= @hour && diff < @hour * 2 ->
        "in 1 hour"

      diff >= @hour * 2 && diff < @day ->
        "in #{div(diff, @hour)} hr"

      diff >= @day && diff < @day * 2 ->
        "tomorrow"

      diff >= @day * 2 && diff < @month ->
        "in #{div(diff, @day)} days"

      diff >= @month && diff < @month * 2 ->
        "in 1 mo"

      diff >= @month * 2 && diff < @year ->
        "in #{div(diff, @month)} mo"

      diff >= @year && diff < @year * 2 ->
        "in 1 year"

      diff >= @year * 2 ->
        "in #{div(diff, @year)} yr"

      # past
      diff < 0 && diff >= -45 ->
        "#{diff * -1} sec ago"

      diff < -45 && diff > @minute * 2 * -1 ->
        "1 min ago"

      diff <= @minute * 2 && diff > @hour * -1 ->
        "#{div(diff * -1, @minute)} min ago"

      diff <= @hour && diff > @hour * 2 * -1 ->
        "1 hour ago"

      diff <= @hour * 2 && diff > @day * -1 ->
        "#{div(diff * -1, @hour)} hr ago"

      diff <= @day && diff > @day * 2 * -1 ->
        "yesterday"

      diff <= @day * 2 && diff > @month * -1 ->
        "#{div(diff * -1, @day)} days ago"

      diff <= @month && diff > @month * 2 * -1 ->
        "1 mo ago"

      diff <= @month * 2 && diff > @year * -1 ->
        "#{div(diff * -1, @month)} mo ago"

      diff <= @year && diff > @year * 2 * -1 ->
        "1 yr ago"

      diff <= @year * 2 * -1 ->
        "#{div(diff * -1, @year)} yr ago"
    end
  end
end
