require 'thor'
require_relative '../../use_cases/ticket_amount_calculator/calculate_use_case'

module TicketAmountCalculator
  #
  # チケットの販売金額を計算するコマンドです。
  #
  class CLI < Thor
    desc 'calculate', 'チケットの販売金額を計算します。'
    def calculate
      presenter = CalculatePresenter.new
      # TODO: 対話形式で入力を受け付ける
      # - チケット枚数（大人）
      # - チケット枚数（子供）
      # - チケット枚数（シニア）
      # - 特別条件（複数指定可）
      CalculateUseCase.call(presenter)
      presenter.output
    end
  end
end
