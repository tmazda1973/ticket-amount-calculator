require_relative './ticket_amount_const'
require_relative '../../enums/ticket_amount_calculator/ticket_type'
require_relative '../../enums/ticket_amount_calculator/special_condition'

module TicketAmountCalculator
  #
  # 金額変更明細の値オブジェクトです。
  #
  class ChangeAmountDetail
    include TicketAmountConst

    #
    # コンストラクタ
    # @param [TicketType] ticket_type チケット種別
    # @param [Integer] adult_ticket_count チケット枚数（大人）
    # @param [Integer] child_ticket_count チケット枚数（子供）
    # @param [Integer] senior_ticket_count チケット枚数（シニア）
    # @param [Array<SpecialCondition>] special_condition 特別条件
    #
    def initialize(
      ticket_type: TicketType::NORMAL,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0,
      special_condition: []
    )
      @ticket_type = ticket_type
      @adult_ticket_count = adult_ticket_count
      @child_ticket_count = child_ticket_count
      @senior_ticket_count = senior_ticket_count
      @special_condition = special_condition
    end

    #
    # 金額変更明細を取得します。
    # @return [Integer] 金額変更明細
    #
    def value
      # TODO: 実装する
    end
  end
end
