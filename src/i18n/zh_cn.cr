module TimeInWords
  module I18n
    module ZH_CN
      extend self

      Map = Hash(Int32, String | Int32).new { |hash, k| hash[k] = "#{k} " }
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

      def distance_in_days(distance : Int) : String
        case distance
        when 1...27   then distance == 1 ? "#{Map[1]}天前" : "#{Map[distance]}天前"
        when 27...60  then "大约#{Map[1]}个月前"
        when 60...365 then "#{Map[(distance / 30).round.to_i]}个月前"
        when 365...730
          "大约#{Map[1]}年前"
        when 730...1460
          "超过#{Map[(distance / 365).round.to_i]}年前"
        else
          "几乎#{Map[(distance / 365).round.to_i]}年前"
        end
      end

      def distance_in_hours(hours : Int32, minutes : Int32) : String
        if minutes >= 45
          "大约#{Map[hours + 1]}小时前"
        elsif hours == 1
          "#{Map[1]}个小时前"
        else
          "#{Map[hours]}小时前"
        end
      end

      def distance_in_minutes(distance : Int32) : String
        case distance
        when 1      then "#{Map[1]}分钟前"
        when 2...45 then "#{Map[distance]}分钟前"
        else
          "大约一个小时前"
        end
      end

      def distance_in_seconds(distance : Int32) : String
        distance == 1 ? "#{Map[1]}秒前" : "#{Map[distance]}秒前"
      end
    end
  end
end
