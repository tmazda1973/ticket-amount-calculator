#
# 基底ユースケースクラスです。
# - このクラスを継承して、ユースケースクラスを作成します。
# @abstract
#
class AppUseCase
  class << self
    #
    # 処理を実行します。
    # @param presenter [BasePresenter] プレゼンター
    # @return [void]
    # @classmethod
    # @abstract
    #
    def call(presenter = nil)
      raise NotImplementedError, 'You must implement the execute method'
    end
  end
end
