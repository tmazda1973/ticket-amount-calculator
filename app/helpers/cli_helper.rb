#
# CLIに関する処理を提供するヘルパーモジュールです。
#
module CLIHelper
  #
  # 水平線を出力します。
  #
  def echo_hr
    puts self.build_hr
  end

  #
  # 水平線を生成します。
  #
  def build_hr
    '-' * (ENV['COLUMNS'] ? ENV['COLUMNS'].to_i : `tput cols`.to_i)
  end

  #
  # 数値をカンマ区切りの文字列に整形します。
  # @param number [Integer,BigDecimal] 数値
  # @return [String] カンマ区切りの文字列
  #
  def number_format(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  end
end
