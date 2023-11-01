require_relative '../../value_objects/ticket_amount/ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../enums/ticket_amount/special_condition'

#
# チケット金額に関する処理を提供するヘルパーモジュールです。
#
module TicketAmount
  module TicketAmountHelper
    include TicketAmountConst

    #
    # チケット枚数情報を構築します。
    # @param adult_count [Integer] チケット枚数（大人）
    # @param child_count [Integer] チケット枚数（子供）
    # @param senior_count [Integer] チケット枚数（シニア）
    # @return [Hash<Symbol>] チケット枚数情報
    #
    def build_ticket_counts(adult_count, child_count, senior_count)
      {
        adult: adult_count,
        child: child_count,
        senior: senior_count
      }
    end

    #
    # チケットの合計金額を算出します。
    # @param ticket_type [Integer] チケット種別
    # @param ticket_count_hash [Hash<Symbol>] チケット枚数情報
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_total_amount(ticket_type, ticket_count_hash)
      adult, child, senior = self._parse_ticket_hash(ticket_count_hash)
      self.calc_adult_ticket_amount(ticket_type, adult) +
        self.calc_child_ticket_amount(ticket_type, child) +
        self.calc_senior_ticket_amount(ticket_type, senior)
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
    # チケット(子供)の合計金額を算出します。
    # @param type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_child_ticket_amount(type, count)
      self.child_ticket_price(type) * count
    end

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
    # 特別条件による金額変更を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param special_conditions [Array] 特別条件
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def change_amount_by_special(total_amount, special_conditions, ticket_counts)
      _total_amount = self.apply_group_discount(total_amount, ticket_counts) # 団体割引
      self.apply_special_conditions(_total_amount, special_conditions, ticket_counts) # 特別条件
      _total_amount
    end

    #
    # 団体割引を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def apply_group_discount(total_amount, ticket_counts)
      _total_amount = total_amount
      if self.group_discount?(ticket_counts)
        _total_amount = (_total_amount * GROUP_DISCOUNT_RATE).floor
      end
      _total_amount
    end

    #
    # 特別条件を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param special_conditions [Array] 特別条件
    # @param ticket_counts [Hash<Symbol>] チケット枚数
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def apply_special_conditions(total_amount, special_conditions, ticket_counts)
      _total_amount = total_amount # 合計金額
      total_count = self._calc_ticket_total_count(ticket_counts)
      # 夕方料金
      if special_conditions.include?(SpecialCondition::EVENING)
        _total_amount -= EVENING_DISCOUNT_PRICE * total_count
      end
      # 休日料金
      if special_conditions.include?(SpecialCondition::HOLIDAY)
        _total_amount += HOLIDAY_EXTRA_PRICE * total_count
      end
      # 月水割引
      if special_conditions.include?(SpecialCondition::MON_WED)
        _total_amount -= MON_WED_DISCOUNT_PRICE * total_count
      end
      _total_amount
    end

    #
    # 団体割引であるかを判定します。
    # @param ticket_count_hash [Hash<Symbol>] チケット枚数情報
    # @return true 団体割引である, false 団体割引ではない
    #
    def group_discount?(ticket_count_hash)
      adult, child, senior = self._parse_ticket_hash(ticket_count_hash)
      ticket_total_count = adult + (child * CHILD_TICKET_WEIGHT) + senior
      ticket_total_count.floor >= GROUP_DISCOUNT_THRESHOLD
    end

    private
    #
    # チケット枚数情報を解析します。
    # @param ticket_count_hash [Hash<Symbol>] チケット枚数情報
    # @return [Array<Integer>] 解析後のチケット枚数情報
    # @private
    #
    def _parse_ticket_hash(ticket_count_hash)
      [
        ticket_count_hash.fetch(:adult, 0).to_i,
        ticket_count_hash.fetch(:child, 0).to_i,
        ticket_count_hash.fetch(:senior, 0).to_i
      ]
    end

    #
    # チケット枚数の合計を算出します。
    # @param ticket_count_hash [Hash<Symbol>] チケット枚数情報
    # @return [Integer] チケット枚数の合計
    # @private
    #
    def _calc_ticket_total_count(ticket_count_hash)
        adult, child, senior = self._parse_ticket_hash(ticket_count_hash)
        adult + child + senior
    end
  end
end
