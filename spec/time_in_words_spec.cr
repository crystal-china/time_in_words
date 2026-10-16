require "./spec_helper"

alias EnglishTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::EN)
alias ChineseTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)

describe TimeInWords do
  describe "unit boundaries" do
    {
      {1.minute - 1.second, "59 seconds", "59 秒"},
      {1.minute, "a minute", "一分钟"},
      {90.seconds - 1.second, "a minute", "一分钟"},
      {90.seconds, "2 minutes", "两分钟"},
      {44.minutes + 29.seconds, "44 minutes", "44 分钟"},
      {44.minutes + 30.seconds, "about an hour", "大约一个小时"},
      {89.minutes + 29.seconds, "about an hour", "大约一个小时"},
      {89.minutes + 30.seconds, "about 2 hours", "大约两小时"},
      {90.minutes, "about 2 hours", "大约两小时"},
      {23.hours + 59.minutes + 29.seconds, "about 24 hours", "大约24 小时"},
      {23.hours + 59.minutes + 30.seconds, "a day", "一天"},
      {41.hours + 59.minutes + 29.seconds, "a day", "一天"},
      {41.hours + 59.minutes + 30.seconds, "2 days", "两天"},
      {42.hours, "2 days", "两天"},
      {59.hours + 59.minutes + 29.seconds, "2 days", "两天"},
      {59.hours + 59.minutes + 30.seconds, "3 days", "三天"},
      {60.hours, "3 days", "三天"},
      {26.days + 11.hours + 59.minutes + 29.seconds, "26 days", "26 天"},
      {26.days + 11.hours + 59.minutes + 30.seconds, "27 days", "27 天"},
      {27.days - 1.second, "27 days", "27 天"},
      {27.days, "about a month", "大约一个月"},
    }.each do |span, english, chinese|
      it "describes #{span} at a unit boundary" do
        EnglishTimeHelper.distance(span: span).should eq english
        ChineseTimeHelper.distance(span: span).should eq chinese
      end
    end
  end

  describe "year boundaries" do
    # A bare span has no calendar dates, so one year is 365 days.
    {
      {365.days, "about a year", "大约一年"},
      {365.days + 365.days / 4 - 1.second, "about a year", "大约一年"},
      {365.days + 365.days / 4, "over 1 year", "超过一年"},
      {365.days + 365.days * 3 / 4 - 1.second, "over 1 year", "超过一年"},
      {365.days + 365.days * 3 / 4, "almost 2 years", "几乎两年"},
      {730.days - 1.second, "almost 2 years", "几乎两年"},
      {730.days, "about 2 years", "大约两年"},
      {1278.days, "over 3 years", "超过三年"},
      {1460.days, "about 4 years", "大约四年"},
      {3650.days, "about 10 years", "大约十年"},
    }.each do |span, english, chinese|
      it "describes #{span} without rounding the completed year count" do
        EnglishTimeHelper.distance(span: span).should eq english
        ChineseTimeHelper.distance(span: span).should eq chinese
      end
    end
  end

  describe "calendar years" do
    {
      {Time.utc(2020, 1, 1), Time.utc(2021, 1, 1), "about a year", "大约一年"},
      {Time.utc(2020, 1, 1), Time.utc(2021, 4, 2), "about a year", "大约一年"},
      {Time.utc(1900, 1, 1), Time.utc(1901, 4, 3), "over 1 year", "超过一年"},
      {Time.utc(2000, 1, 1), Time.utc(2001, 4, 2), "about a year", "大约一年"},
      {Time.utc(2026, 1, 1), Time.utc(2030, 1, 1), "about 4 years", "大约四年"},
      {Time.utc(2020, 1, 1), Time.utc(2100, 1, 1), "about 80 years", "大约80 年"},
      {Time.utc(2020, 3, 1), Time.utc(2021, 3, 1), "about a year", "大约一年"},
      {Time.utc(2023, 3, 1), Time.utc(2024, 2, 29), "about a year", "大约一年"},
    }.each do |from, to, english, chinese|
      it "discounts leap days between #{from} and #{to}" do
        EnglishTimeHelper.distance(from: from, to: to).should eq english
        ChineseTimeHelper.distance(from: from, to: to).should eq chinese
        EnglishTimeHelper.distance(from: to, to: from).should eq english
        ChineseTimeHelper.distance(from: to, to: from).should eq chinese
      end
    end
  end

  describe "reversed distances" do
    {0.seconds, 5.seconds, 5.minutes, 2.hours, 3.days, 400.days}.each do |span|
      it "treats #{span} and its negative as the same distance" do
        EnglishTimeHelper.distance(span: -span).should eq EnglishTimeHelper.distance(span: span)
        ChineseTimeHelper.distance(span: -span).should eq ChineseTimeHelper.distance(span: span)
      end
    end

    it "accepts the two dates in either order" do
      from = Time.utc(2026, 1, 1)
      to = from + 3.days

      EnglishTimeHelper.distance(from: to, to: from).should eq "3 days"
      ChineseTimeHelper.distance(from: to, to: from).should eq "三天"
    end
  end

  describe "future times" do
    it "uses a future phrase instead of ago" do
      now = Time.utc(2026, 10, 20, 12)
      future = now + 2.days + 30.seconds

      EnglishTimeHelper.from(time: future, now: now).should eq "in 2 days"
      ChineseTimeHelper.from(time: future, now: now).should eq "两天后"
    end
  end

  describe "relative elapsed days" do
    location = Time::Location.load("Asia/Shanghai")
    now = Time.local(2026, 10, 20, 14, location: location)

    {
      {Time.local(2026, 10, 17, location: location), "4 days ago", "四天前"},
      {Time.local(2026, 10, 17, 23, location: location), "3 days ago", "三天前"},
      {Time.local(2026, 10, 18, 23, location: location), "a day ago", "一天前"},
      {now - 15.hours, "about 15 hours ago", "大约15 小时前"},
      {now - 1.day + 31.seconds, "about 24 hours ago", "大约24 小时前"},
      {now - 1.day + 30.seconds, "a day ago", "一天前"},
      {now - 1.day + 1.second, "a day ago", "一天前"},
      {now - 1.day, "a day ago", "一天前"},
      {now + 1.day - 1.second, "in a day", "一天后"},
      {now + 1.day, "in a day", "一天后"},
      {now - 60.hours, "3 days ago", "三天前"},
      {Time.local(2026, 10, 23, location: location), "in 2 days", "两天后"},
      {now - 27.days + 1.second, "27 days ago", "27 天前"},
      {now - 27.days, "about a month ago", "大约一个月前"},
    }.each do |time, english, chinese|
      it "describes #{time} relative to #{now} in Shanghai" do
        EnglishTimeHelper.from(time: time, now: now).should eq english
        ChineseTimeHelper.from(time: time, now: now).should eq chinese
      end
    end

    it "is unchanged when the same instant is represented in a different time zone" do
      time = Time.local(2026, 10, 17, location: location)

      {Time::Location::UTC, location, Time::Location.load("America/New_York")}.each do |input_location|
        EnglishTimeHelper.from(time: time.in(input_location), now: now.to_utc).should eq "4 days ago"
        ChineseTimeHelper.from(time: time.in(input_location), now: now.to_utc).should eq "四天前"
      end
    end

    it "leaves pure durations unchanged" do
      EnglishTimeHelper.distance(span: 86.hours).should eq "4 days"
      ChineseTimeHelper.distance(span: 86.hours).should eq "四天"
    end

    it "uses elapsed duration across the spring daylight saving change" do
      new_york = Time::Location.load("America/New_York")
      posted_at = Time.local(2026, 3, 8, location: new_york)
      reference_time = Time.local(2026, 3, 10, location: new_york)

      (reference_time - posted_at).should eq 47.hours
      EnglishTimeHelper.from(time: posted_at, now: reference_time).should eq "2 days ago"
      ChineseTimeHelper.from(time: posted_at, now: reference_time).should eq "两天前"
    end

    it "reports an elapsed day even on the same local date during the autumn clock change" do
      new_york = Time::Location.load("America/New_York")
      posted_at = Time.local(2026, 11, 1, location: new_york)
      reference_time = Time.local(2026, 11, 1, 23, location: new_york)

      (reference_time - posted_at).should eq 24.hours
      reference_time.date.should eq posted_at.date
      EnglishTimeHelper.from(time: posted_at, now: reference_time).should eq "a day ago"
      ChineseTimeHelper.from(time: posted_at, now: reference_time).should eq "一天前"
    end
  end
end
