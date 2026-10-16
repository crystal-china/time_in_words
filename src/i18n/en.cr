module TimeInWords
  module I18n
    module EN
      extend self

      def ago(words : String) : String
        "#{words} ago"
      end

      def distance_in_days(distance : Int32) : String
        case distance
        when 1...27  then distance == 1 ? "a day" : "#{distance} days"
        when 27...60 then "about a month"
        else
          "#{(distance / 30).round(:ties_away).to_i} months"
        end
      end

      def about_years(years : Int32) : String
        years == 1 ? "about a year" : "about #{years} years"
      end

      def over_years(years : Int32) : String
        "over #{years} #{years == 1 ? "year" : "years"}"
      end

      def almost_years(years : Int32) : String
        "almost #{years} #{years == 1 ? "year" : "years"}"
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
  end
end
