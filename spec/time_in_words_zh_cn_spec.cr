require "./spec_helper"
alias ZHHelpers = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)

describe "TimeInWords" do
  describe "distance for cn" do
    it "reports the approximate distance in time between two Time" do
      from_time = Time.utc(2026, 1, 1)
      ZHHelpers.distance(from: from_time, to: from_time).should eq "零秒"
      ZHHelpers.distance(from: from_time, to: from_time + 1.second).should eq "一秒"
      ZHHelpers.distance(from: from_time, to: from_time + 10.seconds).should eq "十秒"
      ZHHelpers.distance(from: from_time, to: from_time + 1.minute).should eq "一分钟"
      ZHHelpers.distance(from: from_time, to: from_time + 2.minutes).should eq "两分钟"
      ZHHelpers.distance(from: from_time, to: from_time + 35.minutes).should eq "35 分钟"
      ZHHelpers.distance(from: from_time, to: from_time + 50.minutes).should eq "大约一个小时"
      ZHHelpers.distance(from: from_time, to: from_time + 1.hour).should eq "大约一个小时"
      ZHHelpers.distance(from: from_time, to: from_time + 110.minutes).should eq "大约两小时"
      ZHHelpers.distance(from: from_time, to: from_time + 350.minutes).should eq "大约六小时"
      ZHHelpers.distance(from: from_time, to: from_time + 2.hours).should eq "大约两小时"
      ZHHelpers.distance(from: from_time, to: from_time + 1.day).should eq "一天"
      ZHHelpers.distance(from: from_time, to: from_time + 10.days).should eq "十天"
    end

    {
      {26, "26 天"},
      {27, "27 天"},
      {37, "大约一个月"},
      {38, "大约一个半月"},
      {51, "大约一个半月"},
      {52, "两个月"},
      {74, "两个月"},
      {75, "三个月"},
      {76, "三个月"},
      {364, "12 个月"},
      {365, "大约一年"},
      {729, "几乎两年"},
      {730, "大约两年"},
      {1459, "几乎四年"},
      {1460, "几乎四年"},
    }.each do |days, expected|
      it "describes #{days} days as #{expected}" do
        from_time = Time.utc(2026, 1, 1)

        ZHHelpers.distance(from: from_time, to: from_time + days.days).should eq expected
      end
    end

    it "takes a Time::Span" do
      span = 4.minutes
      ZHHelpers.distance(span: span).should eq "四分钟"
    end
  end

  describe "from" do
    it "returns the distance from now" do
      ZHHelpers.from(time: Time.local - 13.months).should eq "大约一年前"
    end

    it "describes the current moment as just now" do
      ZHHelpers.from(time: Time.utc).should eq "刚刚"
    end
  end
end
