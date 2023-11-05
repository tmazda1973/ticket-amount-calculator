require_relative '../../constants//ticket_amount/ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../enums/ticket_amount/special_condition'

#
# チケット金額に関する処理を提供するヘルパーモジュールです。
#
module TicketAmount
  module TicketAmountHelper
    include TicketAmountConst

    #
    # チケット枚数ホルダーを構築します。
    # @param adult [Integer] チケット枚数（大人）
    # @param child [Integer] チケット枚数（子供）
    # @param senior [Integer] チケット枚数（シニア）
    # @return [TicketCountHolder] チケット枚数ホルダー
    #
    def build_ticket_count_holder(adult, child, senior)
      TicketCountHolder.new(adult: adult, child: child, senior: senior)
    end

    #
    # チケットの合計金額を算出します。
    # @param ticket_type [Integer] チケット種別
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_total_amount(ticket_type, ticket_count_holder)
      self.calc_adult_ticket_amount(ticket_type, ticket_count_holder.adult) +
        self.calc_child_ticket_amount(ticket_type, ticket_count_holder.child) +
        self.calc_senior_ticket_amount(ticket_type, ticket_count_holder.senior)
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
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def change_amount_by_special(total_amount, special_conditions, ticket_count_holder)
      _total_amount = total_amount
      _total_amount = self.apply_special_conditions(_total_amount, special_conditions, ticket_count_holder) # 特別条件
      self.apply_group_discount(_total_amount, ticket_count_holder) # 団体割引
    end

    #
    # 団体割引を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def apply_group_discount(total_amount, ticket_count_holder)
      _total_amount = total_amount
      if self.group_discount?(ticket_count_holder)
        _total_amount = (_total_amount * GROUP_DISCOUNT_RATE).floor
      end
      _total_amount
    end

    #
    # 特別条件を適用します。
    # @param total_amount [Integer,BigDecimal] 合計金額
    # @param special_conditions [Array] 特別条件
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return [Integer,BigDecimal] 適用後の合計金額
    #
    def apply_special_conditions(total_amount, special_conditions, ticket_count_holder)
      _total_amount = total_amount # 合計金額
      total_count = self._calc_ticket_total_count(ticket_count_holder)
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
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return true 団体割引である, false 団体割引ではない
    #
    def group_discount?(ticket_count_holder)
      ticket_total_count = [
        ticket_count_holder.adult,
        (ticket_count_holder.child * CHILD_TICKET_WEIGHT),
        ticket_count_holder.senior
      ].sum
      ticket_total_count.floor >= GROUP_DISCOUNT_THRESHOLD
    end

    private
    #
    # チケット枚数の合計を算出します。
    # @param ticket_count_holder [TicketCountHolder] チケット枚数ホルダー
    # @return [Integer] チケット枚数の合計
    # @private
    #
    def _calc_ticket_total_count(ticket_count_holder)
      [
        ticket_count_holder.adult,
        ticket_count_holder.child,
        ticket_count_holder.senior
      ].sum
    end

    #
    # チケット枚数ホルダークラスです。
    # @private
    #
    class TicketCountHolder
      attr_accessor :adult, :child, :senior
      #
      # コンストラクタ
      # @param adult [Integer] チケット枚数（大人）
      # @param child [Integer] チケット枚数（子供）
      # @param senior [Integer] チケット枚数（シニア）
      #
      def initialize(adult: 0, child: 0, senior: 0)
        self.adult = adult
        self.child = child
        self.senior = senior
      end
    end
  end
end
