#
# 文字列に関する処理を提供するヘルパーモジュールです。
#
module StringHelper
  #
  # 数値をカンマ区切りの文字列に整形します。
  # @param number [Integer,BigDecimal] 数値
  # @return [String] カンマ区切りの文字列
  #
  def number_format(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  end
end
