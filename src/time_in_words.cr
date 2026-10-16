require "./i18n/*"

module TimeInWords
  module Helpers(T)
    extend self

    # Returns a `String` with approximate distance in time between `from` and `to`.
    #
    # ```
    # distance_of_time_in_words(Time.utc(2019, 8, 14, 10, 0, 0), Time.utc(2019, 8, 14, 10, 0, 5))
    # # => "5 seconds"
    # distance_of_time_in_words(Time.utc(2019, 8, 14, 10, 0), Time.utc(2019, 8, 14, 10, 25))
    # # => "25 minutes"
    # distance_of_time_in_words(Time.utc(2019, 8, 14, 10), Time.utc(2019, 8, 14, 11))
    # # => "an hour"
    # distance_of_time_in_words(Time.utc(2019, 8, 14), Time.utc(2019, 8, 16))
    # # => "2 days"
    # distance_of_time_in_words(Time.utc(2019, 8, 14), Time.utc(2019, 10, 4))
    # # => "about a month"
    # distance_of_time_in_words(Time.utc(2019, 8, 14), Time.utc(2061, 10, 4))
    # # => "about 42 years"
    # ```
    def distance(*, from : Time, to : Time) : String
      distance_of_time_in_words(from: from, to: to)
    end

    # :ditto:
    def distance(*, span : Time::Span) : String
      distance_of_time_in_words(span: span)
    end

    # Returns a `String` with approximate distance in time between `from` and current moment.
    def from(*, past_time : Time) : String
      T.ago(time_in_words(from: past_time))
    end

    private def distance_of_time_in_words(*, from : Time, to : Time) : String
      from, to = to, from if from > to
      distance_of_time_in_words(span: to - from)
    end

    private def distance_of_time_in_words(*, span : Time::Span) : String
      span = span.abs

      return distance_in_years(span) if span >= 365.days

      minutes = span.minutes.to_i32
      seconds = span.seconds.to_i32
      hours = span.hours.to_i32
      days = span.days.to_i32

      return T.distance_in_days(days) if days != 0
      return T.distance_in_hours(hours, minutes) if hours != 0
      return T.distance_in_minutes(minutes) if minutes != 0

      T.distance_in_seconds(seconds)
    end

    private def time_in_words(*, from : Time) : String
      distance_of_time_in_words(from: from, to: Time.utc)
    end

    private def distance_in_years(span : Time::Span) : String
      years = (span.days // 365).to_i32
      remainder = span - (years * 365).days

      if remainder < 365.days / 4
        T.about_years(years)
      elsif remainder < 365.days * 3 / 4
        T.over_years(years)
      else
        T.almost_years(years + 1)
      end
    end
  end
end
