module TimeInWords
  module I18n
    module ZH_CN
      extend self

      Map = Hash(Int32, String).new { |hash, k| hash[k] = "#{k} " }
      Map[0] = "零"
      Map[1] = "一"
      Map[2] = "两"
      Map[3] = "三"
      Map[4] = "四"
      Map[5] = "五"
      Map[6] = "六"
      Map[7] = "七"
      Map[8] = "八"
      Map[9] = "九"
      Map[10] = "十"

      def ago(words : String) : String
        words == "零秒" ? "刚刚" : "#{words}前"
      end

      def from_now(words : String) : String
        "#{words}后"
      end

      def distance_in_days(distance : Int32) : String
        case distance
        when 30...38  then "大约#{Map[1]}个月"
        when 38...52  then "大约#{Map[1]}个半月"
        when 52...365 then "#{Map[(distance / 30).round(:ties_away).to_i]}个月"
        else
          days(distance)
        end
      end

      def days(count : Int32) : String
        "#{Map[count]}天"
      end

      def about_years(years : Int32) : String
        "大约#{Map[years]}年"
      end

      def over_years(years : Int32) : String
        "超过#{Map[years]}年"
      end

      def almost_years(years : Int32) : String
        "几乎#{Map[years]}年"
      end

      def distance_in_hours(hours : Int32) : String
        hours == 1 ? "大约一个小时" : "大约#{Map[hours]}小时"
      end

      def distance_in_minutes(distance : Int32) : String
        "#{Map[distance]}分钟"
      end

      def distance_in_seconds(distance : Int32) : String
        "#{Map[distance]}秒"
      end
    end
  end
end
