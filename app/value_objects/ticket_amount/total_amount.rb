require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../helpers/ticket_amount/ticket_amount_helper'

module TicketAmount
  #
  # 販売合計金額の値オブジェクトです。
  #
  class TotalAmount
    include TicketAmountHelper

    #
    # コンストラクタ
    # @param [TicketType] ticket_type チケット種別
    # @param [Integer] adult_ticket_count チケット枚数（大人）
    # @param [Integer] child_ticket_count チケット枚数（子供）
    # @param [Integer] senior_ticket_count チケット枚数（シニア）
    # @param [Array<SpecialCondition>] special_conditions 特別条件
    #
    def initialize(
      ticket_type: TicketType::NORMAL,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0,
      special_conditions: []
    )
      @ticket_type = ticket_type
      @adult_count = adult_ticket_count
      @child_count = child_ticket_count
      @senior_count = senior_ticket_count
      @special_conditions = special_conditions
    end

    #
    # 販売合計金額を取得します。
    # @return [Integer,BigDecimal] 販売合計金額
    #
    def value
      ticket_counts = self.build_ticket_counts(@adult_count, @child_count, @senior_count)
      total_amount = self.calc_total_amount(@ticket_type, ticket_counts)
      self.change_amount_by_special(total_amount, @special_conditions, ticket_counts)
    end
  end
end
