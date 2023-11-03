require_relative '../app_use_case'
require_relative '../../repositories/ticket_amount/calculate_repository'

module TicketAmount
  #
  # チケットの販売金額を計算するアクションのユースケースです。
  #
  class CalculateUseCase < AppUseCase
    #
    # コンストラクタ
    #
    def initialize
      @repository = CalculateRepository.new
    end

    # @see AppUseCase#execute
    def execute(presenter)
      # 販売合計金額
      presenter.total_amount = @repository.calc_total_amount(
        presenter.ticket_type,
        adult_ticket_count: presenter.adult_ticket_count,
        child_ticket_count: presenter.child_ticket_count,
        senior_ticket_count: presenter.senior_ticket_count,
        special_conditions: presenter.special_conditions
      )
      # 変更前合計金額
      presenter.before_total_amount = @repository.calc_before_total_amount(
        presenter.ticket_type,
        adult_ticket_count: presenter.adult_ticket_count,
        child_ticket_count: presenter.child_ticket_count,
        senior_ticket_count: presenter.senior_ticket_count
      )
      # 金額変更明細
      presenter.change_amount_detail = @repository.change_amount_detail(
        presenter.ticket_type,
        adult_ticket_count: presenter.adult_ticket_count,
        child_ticket_count: presenter.child_ticket_count,
        senior_ticket_count: presenter.senior_ticket_count,
        special_conditions: presenter.special_conditions
      )
    end
  end
end
