require "./spec_helper"

alias EnglishTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::EN)
alias ChineseTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)

describe TimeInWords do
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
