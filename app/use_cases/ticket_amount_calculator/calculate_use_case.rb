require_relative '../app_use_case'

module TicketAmountCalculator
  #
  # チケットの販売金額を計算するユースケースです。
  #
  class CalculateUseCase < AppUseCase
    class << self
      # @implements AppUseCase#call
      def call(presenter = nil)
        puts 'calculate ticket amount'
      end
    end
  end
end
