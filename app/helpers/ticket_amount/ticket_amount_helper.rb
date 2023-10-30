require_relative '../../value_objects/ticket_amount/ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'

#
# チケット金額に関する処理を提供するヘルパーモジュールです。
#
module TicketAmount
  module TicketAmountHelper
    include TicketAmountConst

    #
    # チケット(大人)の単価を取得します。
    # @param type [Integer] チケット種別
    # @return [Integer,BigDecimal] 単価
    #
    def adult_ticket_price(type)
      if type === TicketType::SPECIAL
        ADULT_TICKET_PRICE_SPECIAL
      else
        ADULT_TICKET_PRICE
      end
    end

    #
    # チケット(大人)の合計金額を算出します。
    # @param type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_adult_ticket_amount(type, count)
      self.adult_ticket_price(type) * count
    end

    #
    # チケット(子供)の単価を取得します。
    # @param type [Integer] チケット種別
    # @return [Integer,BigDecimal] 単価
    #
    def child_ticket_price(type)
      if type === TicketAmount::TicketType::SPECIAL
        CHILD_TICKET_PRICE_SPECIAL
      else
        CHILD_TICKET_PRICE
      end
    end

    #
    # チケット(子供)の合計金額を算出します。
    # @param type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_child_ticket_amount(type, count)
      self.child_ticket_price(type) * count
    end

    #
    # チケット(シニア)の単価を取得します。
    # @param type [Integer] チケット種別
    # @return [Integer,BigDecimal] チケット単価
    #
    def senior_ticket_price(type)
      if type === TicketAmount::TicketType::SPECIAL
        SENIOR_TICKET_PRICE_SPECIAL
      else
        SENIOR_TICKET_PRICE
      end
    end

    #
    # チケット(シニア)の合計金額を算出します。
    # @param type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_senior_ticket_amount(type, count)
      self.senior_ticket_price(type) * count
    end
  end
end
