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

      def distance_in_days(distance : Int32) : String
        case distance
        when 27...38  then "大约#{Map[1]}个月"
        when 38...52  then "大约#{Map[1]}个半月"
        when 52...365 then "#{Map[(distance / 30).round(:ties_away).to_i]}个月"
        when 365...730
          "大约#{Map[1]}年"
        when 730...1460
          "超过#{Map[(distance / 365).round.to_i]}年"
        when 1460...
          "几乎#{Map[(distance / 365).round.to_i]}年"
        else
          "#{Map[distance]}天"
        end
      end

      def distance_in_hours(hours : Int32, minutes : Int32) : String
        if minutes >= 45
          "大约#{Map[hours + 1]}小时"
        elsif hours == 1
          "#{Map[1]}个小时"
        else
          "#{Map[hours]}小时"
        end
      end

      def distance_in_minutes(distance : Int32) : String
        case distance
        when 1      then "#{Map[1]}分钟"
        when 2...45 then "#{Map[distance]}分钟"
        else
          "大约#{Map[1]}个小时"
        end
      end

      def distance_in_seconds(distance : Int32) : String
        "#{Map[distance]}秒"
      end
    end
  end
end
