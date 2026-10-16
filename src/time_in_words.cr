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
      span = to - from

      if span >= 365.days
        # Match Rails: discount leap days before choosing the year phrase.

        # 处理闰年二月份多一天的情况，因为闰年无法 365 整除，可能对年份误判。

        # 数哪些年份的 2 月可能落在这段时间内。
        # 开始年份过了二月，from + 1 从下一年开始数
        # 结束年份 2 月 29 日还没到，to - 1，因此这一年不计入
        from_year = from.year + (from.month >= 3 ? 1 : 0)
        to_year = to.year - (to.month < 3 ? 1 : 0)
        leap_days = 0

        if from_year <= to_year
          # 公历闰年规则：

          # • 能被 4 整除，通常是闰年。
          # • 能被 100 整除，排除。
          # • 但能被 400 整除，再加回来。
          # 例如：截至 2024 年：506 - 20 + 5 = 491

          # 先算到前一年有多少闰年
          # 再算到截止年有多少闰年。
          # 减一下就知道区间内有几个闰年了。
          previous_year = from_year - 1
          leap_days = (to_year // 4 - to_year // 100 + to_year // 400) -
                      (previous_year // 4 - previous_year // 100 + previous_year // 400)
        end

        # 扣除区间内所有闰年额外的一天，减少按每年 365 天计算时的偏差
        # span - leap_days.days 总是可以被 365 整除，不会算错年份。
        return distance_in_years(span - leap_days.days)
      end

      distance_of_time_in_words(span: span)
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
