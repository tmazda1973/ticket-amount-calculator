#
# 基底プレゼンタークラスです。
# - このクラスを継承して、プレゼンタークラスを作成します。
# @abstract
#
class AppPresenter
  #
  # 出力処理を実行します。
  # @return [void]
  # @abstract
  #
  def output
    raise NotImplementedError, 'This method must be implemented in child classes'
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
