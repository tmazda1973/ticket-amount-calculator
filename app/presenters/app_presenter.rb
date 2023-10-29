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
    raise NotImplementedError, 'You must implement the output method'
  end
end
