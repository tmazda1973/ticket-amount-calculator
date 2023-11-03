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
end
