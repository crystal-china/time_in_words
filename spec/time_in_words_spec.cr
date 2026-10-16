require "./spec_helper"

alias EnglishTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::EN)
alias ChineseTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)

describe TimeInWords do
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
end
