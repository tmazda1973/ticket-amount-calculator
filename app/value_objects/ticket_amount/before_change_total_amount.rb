require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../helpers/ticket_amount/ticket_amount_helper'

module TicketAmount
  #
  # 金額変更前合計金額の値オブジェクトです。
  #
  class BeforeChangeTotalAmount
    include TicketAmountHelper

    #
    # コンストラクタ
    # @param [TicketType] ticket_type チケット種別
    # @param [Integer] adult_ticket_count チケット枚数（大人）
    # @param [Integer] child_ticket_count チケット枚数（子供）
    # @param [Integer] senior_ticket_count チケット枚数（シニア）
    #
    def initialize(
      ticket_type: TicketType::NORMAL,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0
    )
      @ticket_type = ticket_type
      @adult_ticket_count = adult_ticket_count
      @child_ticket_count = child_ticket_count
      @senior_ticket_count = senior_ticket_count
    end

    #
    # 金額変更前合計金額を取得します。
    # @return [Integer,BigDecimal] 金額変更前合計金額
    #
    def value
      self.calc_adult_ticket_amount(@ticket_type, @adult_ticket_count) +
        self.calc_child_ticket_amount(@ticket_type, @child_ticket_count) +
        self.calc_senior_ticket_amount(@ticket_type, @senior_ticket_count)
    end
  end
end
