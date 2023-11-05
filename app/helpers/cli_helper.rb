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
end
