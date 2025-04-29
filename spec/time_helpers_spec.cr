require "./spec_helper"
include TimeInWords

describe TimeInWords do
  describe "distance_of_time_in_words" do
    it "reports the approximate distance in time between two Time" do
      from_time = Time.local
      distance_of_time_in_words(from_time, from_time + 1.second).should eq "a second"
      distance_of_time_in_words(from_time, from_time + 10.seconds).should eq "10 seconds"
      distance_of_time_in_words(from_time, from_time + 1.minute).should eq "a minute"
      distance_of_time_in_words(from_time, from_time + 2.minutes).should eq "2 minutes"
      distance_of_time_in_words(from_time, from_time + 35.minutes).should eq "35 minutes"
      distance_of_time_in_words(from_time, from_time + 45.minutes).should eq "about an hour"
      distance_of_time_in_words(from_time, from_time + 50.minutes).should eq "about an hour"
      distance_of_time_in_words(from_time, from_time + 1.hour).should eq "an hour"
      distance_of_time_in_words(from_time, from_time + 110.minutes).should eq "almost 2 hours"
      distance_of_time_in_words(from_time, from_time + 350.minutes).should eq "almost 6 hours"
      distance_of_time_in_words(from_time, from_time + 2.hours).should eq "2 hours"
      distance_of_time_in_words(from_time, from_time + 1.day).should eq "a day"
      distance_of_time_in_words(from_time, from_time + 10.days).should eq "10 days"
      distance_of_time_in_words(from_time, from_time + 1.month).should eq "about a month"
      distance_of_time_in_words(from_time, from_time + 10.months).should eq "10 months"
      distance_of_time_in_words(from_time, from_time + 12.months).should eq "about a year"
      distance_of_time_in_words(from_time, from_time + 2.years).should eq "over 2 years"
      distance_of_time_in_words(from_time, from_time + 10.years).should eq "almost 10 years"
    end

    it "takes a Time::Span" do
      span = 4.minutes
      distance_of_time_in_words(span).should eq "4 minutes"
    end
  end

  describe "time_ago_in_words" do
    it "returns the distance from now" do
      time_ago_in_words(Time.local - 13.months).should eq "about a year"
    end
  end

  describe "time_from_now_in_words" do
    it "returns the distance between now and future date" do
      time_from_now_in_words(Time.local + 13.months).should eq "about a year"
    end
  end
end
