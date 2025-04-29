module TimeInWords::I18n::EN
  extend self

  def distance_in_days(distance : Int) : String
    case distance
    when 1...27   then distance == 1 ? "a day" : "#{distance} days"
    when 27...60  then "about a month"
    when 60...365 then "#{(distance / 30).round.to_i} months"
    when 365...730
      "about a year"
    when 730...1460
      "over #{(distance / 365).round.to_i} years"
    else
      "almost #{(distance / 365).round.to_i} years"
    end
  end

  def distance_in_hours(hours : Int32, minutes : Int32) : String
    if minutes >= 45
      "almost #{hours + 1} hours"
    elsif hours == 1
      "an hour"
    else
      "#{hours} hours"
    end
  end

  def distance_in_minutes(distance : Int32) : String
    case distance
    when 1      then "a minute"
    when 2...45 then "#{distance} minutes"
    else
      "about an hour"
    end
  end

  def distance_in_seconds(distance : Int32) : String
    distance == 1 ? "a second" : "#{distance} seconds"
  end
end
