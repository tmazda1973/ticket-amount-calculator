require_relative '../app_repository'
require_relative '../../value_objects/ticket_amount/total_amount'
require_relative '../../value_objects/ticket_amount/before_total_amount'
require_relative '../../value_objects/ticket_amount/change_amount_detail'

module TicketAmount
  #
  # チケットの販売金額を計算するアクションのリポジトリーです。
  #
  class CalculateRepository
    #
    # 合計金額を算出します。
    # @param ticket_type [TicketType] チケット種別
    # @param adult_ticket_count [Integer] チケット枚数（大人）
    # @param child_ticket_count [Integer] チケット枚数（子供）
    # @param senior_ticket_count [Integer] チケット枚数（シニア）
    # @param special_conditions [Array<SpecialCondition>] 特別条件
    # @return [Integer,BigDecimal] 合計金額
    #
    def calc_total_amount(
      ticket_type,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0,
      special_conditions: []
    )
      TotalAmount.new(
        ticket_type: ticket_type,
        adult_ticket_count: adult_ticket_count,
        child_ticket_count: child_ticket_count,
        senior_ticket_count: senior_ticket_count,
        special_conditions: special_conditions
      ).value
    end

    #
    # 変更前合計金額を算出します。
    # @param ticket_type [TicketType] チケット種別
    # @param adult_ticket_count [Integer] チケット枚数（大人）
    # @param child_ticket_count [Integer] チケット枚数（子供）
    # @param senior_ticket_count [Integer] チケット枚数（シニア）
    # @return [Integer,BigDecimal] 変更前合計金額
    #
    def calc_before_total_amount(
      ticket_type,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0
    )
      BeforeTotalAmount.new(
        ticket_type: ticket_type,
        adult_ticket_count: adult_ticket_count,
        child_ticket_count: child_ticket_count,
        senior_ticket_count: senior_ticket_count
      ).value
    end

    #
    # 金額変更明細を取得します。
    # @param ticket_type [TicketType] チケット種別
    # @param adult_ticket_count [Integer] チケット枚数（大人）
    # @param child_ticket_count [Integer] チケット枚数（子供）
    # @param senior_ticket_count [Integer] チケット枚数（シニア）
    # @param special_conditions [Array<SpecialCondition>] 特別条件
    # @return [Array<String>] 金額変更明細
    #
    def change_amount_detail(
      ticket_type,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0,
      special_conditions: []
    )
      ChangeAmountDetail.new(
        ticket_type: ticket_type,
        adult_ticket_count: adult_ticket_count,
        child_ticket_count: child_ticket_count,
        senior_ticket_count: senior_ticket_count,
        special_conditions: special_conditions
      ).value
    end
  end
end
