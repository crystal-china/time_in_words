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
    # # => "almost 42 years"
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
      time_in_words(from: past_time)
    end

    private def distance_of_time_in_words(*, from : Time, to : Time) : String
      distance_of_time_in_words(span: to - from)
    end

    private def distance_of_time_in_words(*, span : Time::Span) : String
      minutes = span.minutes
      seconds = span.seconds
      hours = span.hours
      days = span.days

      return T.distance_in_days(days) if days != 0
      return T.distance_in_hours(hours, minutes) if hours != 0
      return T.distance_in_minutes(minutes) if minutes != 0

      T.distance_in_seconds(seconds)
    end

    private def time_in_words(*, from : Time) : String
      distance_of_time_in_words(from: from, to: Time.utc)
    end
  end
end
