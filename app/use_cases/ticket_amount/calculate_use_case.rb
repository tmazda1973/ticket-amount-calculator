require_relative '../app_use_case'
require_relative '../../value_objects/ticket_amount/total_amount'
require_relative '../../value_objects/ticket_amount/before_change_total_amount'
require_relative '../../value_objects/ticket_amount/change_amount_detail'

module TicketAmount
  #
  # チケットの販売金額を計算するユースケースです。
  #
  class CalculateUseCase < AppUseCase
    class << self
      # @implements AppUseCase#call
      def call(presenter)
        # 販売合計金額
        presenter.total_amount = TotalAmount.new(
          ticket_type: presenter.ticket_type,
          adult_ticket_count: presenter.adult_ticket_count,
          child_ticket_count: presenter.child_ticket_count,
          senior_ticket_count: presenter.senior_ticket_count,
          special_conditions: presenter.special_conditions
        ).value
        # 金額変更前合計金額
        presenter.before_change_total_amount = BeforeChangeTotalAmount.new(
          ticket_type: presenter.ticket_type,
          adult_ticket_count: presenter.adult_ticket_count,
          child_ticket_count: presenter.child_ticket_count,
          senior_ticket_count: presenter.senior_ticket_count
        ).value
        # 金額変更明細
        presenter.change_amount_detail = ChangeAmountDetail.new(
          ticket_type: presenter.ticket_type,
          adult_ticket_count: presenter.adult_ticket_count,
          child_ticket_count: presenter.child_ticket_count,
          senior_ticket_count: presenter.senior_ticket_count,
          special_conditions: presenter.special_conditions
        ).value
      end
    end
  end
end
