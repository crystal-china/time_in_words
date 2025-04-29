require "./spec_helper"
alias ZHHelpers = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)
include ZHHelpers

describe "TimeInWords" do
  describe "distance_of_time_in_words for cn" do
    it "reports the approximate distance in time between two Time" do
      from_time = Time.local
      distance_of_time_in_words(from: from_time, to: from_time + 1.second).should eq "一秒前"
      distance_of_time_in_words(from: from_time, to: from_time + 10.seconds).should eq "十秒前"
      distance_of_time_in_words(from: from_time, to: from_time + 1.minute).should eq "一分钟前"
      distance_of_time_in_words(from: from_time, to: from_time + 2.minutes).should eq "两分钟前"
      distance_of_time_in_words(from: from_time, to: from_time + 35.minutes).should eq "35 分钟前"
      distance_of_time_in_words(from: from_time, to: from_time + 45.minutes).should eq "大约一个小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 50.minutes).should eq "大约一个小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 1.hour).should eq "一个小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 110.minutes).should eq "大约两小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 350.minutes).should eq "大约六小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 2.hours).should eq "两小时前"
      distance_of_time_in_words(from: from_time, to: from_time + 1.day).should eq "一天前"
      distance_of_time_in_words(from: from_time, to: from_time + 10.days).should eq "十天前"
      distance_of_time_in_words(from: from_time, to: from_time + 1.month).should eq "大约一个月前"
      distance_of_time_in_words(from: from_time, to: from_time + 10.months).should eq "十个月前"
      distance_of_time_in_words(from: from_time, to: from_time + 12.months).should eq "大约一年前"
      distance_of_time_in_words(from: from_time, to: from_time + 2.years).should eq "超过两年前"
      distance_of_time_in_words(from: from_time, to: from_time + 10.years).should eq "几乎十年前"
      ZHHelpers.distance(from: from_time, to: from_time + 10.years).should eq "几乎十年前"
    end

    it "takes a Time::Span" do
      span = 4.minutes
      distance_of_time_in_words(span: span).should eq "四分钟前"
      ZHHelpers.distance(span: span).should eq "四分钟前"
    end
  end

  describe "time_in_words" do
    it "returns the distance from now" do
      time_in_words(from: Time.local - 13.months).should eq "大约一年前"
      ZHHelpers.from(past_time: Time.local - 13.months).should eq "大约一年前"
    end
  end
end
