#
# 基底ユースケースクラスです。
# - このクラスを継承して、ユースケースクラスを作成します。
# @abstract
#
class AppUseCase
  class << self
    #
    # 処理を実行します。
    # @param presenter [AppPresenter] プレゼンター
    # @return [void]
    # @classmethod
    #
    def call(presenter = nil)
      self.new.execute(presenter)
    end
  end

  #
  # 処理を実行します。
  # @param presenter [AppPresenter, nil] プレゼンター
  # @return [void]
  # @abstract
  #
  def execute(presenter = nil)
    raise NotImplementedError, 'This method must be implemented in child classes'
  end
end
