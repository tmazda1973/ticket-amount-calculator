require_relative './ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'

module TicketAmount
  #
  # 金額変更前合計金額の値オブジェクトです。
  #
  class BeforeChangeTotalAmount
    include TicketAmountConst

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
    # @return [Integer] 金額変更前合計金額
    #
    def value
      case @ticket_type
      when TicketType::SPECIAL # 特別
        total_amount =
          @adult_ticket_count * ADULT_TICKET_PRICE_SPECIAL +
            @child_ticket_count * CHILD_TICKET_PRICE_SPECIAL +
            @senior_ticket_count * SENIOR_TICKET_PRICE_SPECIAL
      else # 通常
        total_amount =
          @adult_ticket_count * ADULT_TICKET_PRICE +
            @child_ticket_count * CHILD_TICKET_PRICE +
            @senior_ticket_count * SENIOR_TICKET_PRICE
      end
      total_amount
    end
  end
end
