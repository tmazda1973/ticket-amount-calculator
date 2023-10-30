require_relative './ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../enums/ticket_amount/special_condition'

module TicketAmount
  #
  # 販売合計金額の値オブジェクトです。
  #
  class TotalAmount
    include TicketAmountConst

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
      @adult_ticket_count = adult_ticket_count
      @child_ticket_count = child_ticket_count
      @senior_ticket_count = senior_ticket_count
      @special_conditions = special_conditions
    end

    #
    # 販売合計金額を取得します。
    # @return [Integer, BigDecimal] 販売合計金額
    #
    def value
      case @ticket_type
      when TicketType::SPECIAL # 特別
        total_amount =
          @adult_ticket_count * self::ADULT_TICKET_PRICE_SPECIAL +
            @child_ticket_count * self::CHILD_TICKET_PRICE_SPECIAL +
            @senior_ticket_count * self::SENIOR_TICKET_PRICE_SPECIAL
      else # 通常
        total_amount =
          @adult_ticket_count * self::ADULT_TICKET_PRICE +
            @child_ticket_count * self::CHILD_TICKET_PRICE +
            @senior_ticket_count * self::SENIOR_TICKET_PRICE
      end
      # 条件によって料金を変更する
      ticket_counts = {
        adult: @adult_ticket_count,
        child: @child_ticket_count,
        senior: @senior_ticket_count
      }
      total_amount = self._apply_group_discount(total_amount, ticket_counts) # 団体割引
      self._apply_special_conditions(total_amount, @special_conditions, ticket_counts) # 特別条件
    end

    private
    #
    # 団体割引を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer,BigDecimal] 適用後の合計金額
    # @private
    #
    def _apply_group_discount(total_amount, ticket_counts)
      _total_amount = total_amount
      if self._group_discount?(ticket_counts)
        _total_amount = (_total_amount * self::GROUP_DISCOUNT_RATE).floor
      end
      _total_amount
    end

    #
    # チケット枚数の合計を算出します。
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer] チケット枚数の合計
    # @private
    #
    def _calc_ticket_total_count(ticket_counts)
      ticket_counts[:adult] + ticket_counts[:child] + ticket_counts[:senior]
    end

    #
    # 特別条件を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param special_conditions [Array] 特別条件
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer,BigDecimal] 適用後の合計金額
    # @private
    #
    def _apply_special_conditions(total_amount, special_conditions, ticket_counts)
      _total_amount = total_amount # 合計金額
      total_count = self._calc_ticket_total_count(ticket_counts[:adult])
      # 夕方料金
      if special_conditions.include?(SpecialCondition::EVENING)
        _total_amount -= self::EVENING_DISCOUNT_PRICE * total_count
      end
      # 休日料金
      if special_conditions.include?(SpecialCondition::HOLIDAY)
        _total_amount += self::HOLIDAY_EXTRA_PRICE * total_count
      end
      # 月水割引
      if special_conditions.include?(SpecialCondition::MON_WED)
        _total_amount -= self::MON_WED_DISCOUNT_PRICE * total_count
      end
      _total_amount
    end

    #
    # 団体割引であるかを判定します。
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return true 団体割引である, false 団体割引ではない
    # @private
    #
    def _group_discount?(ticket_counts)
      ticket_total_count =
        ticket_counts[:adult] +
          (ticket_counts[:child] * self::CHILD_TICKET_WEIGHT) +
          ticket_counts[:senior]
      ticket_total_count.floor >= self::GROUP_DISCOUNT_THRESHOLD
    end
  end
end
