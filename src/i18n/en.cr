module TimeInWords
  module I18n
    module EN
      extend self

      def ago(words : String) : String
        "#{words} ago"
      end

      def from_now(words : String) : String
        "in #{words}"
      end

      def distance_in_days(distance : Int32) : String
        case distance
        when 1...27  then days(distance)
        when 27...60 then "about a month"
        else
          "#{(distance / 30).round(:ties_away).to_i} months"
        end
      end

      def days(count : Int32) : String
        count == 1 ? "a day" : "#{count} days"
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

      def distance_in_hours(hours : Int32) : String
        hours == 1 ? "about an hour" : "about #{hours} hours"
      end

      def distance_in_minutes(distance : Int32) : String
        distance == 1 ? "a minute" : "#{distance} minutes"
      end

      def distance_in_seconds(distance : Int32) : String
        distance == 1 ? "a second" : "#{distance} seconds"
      end
    end
  end
end
