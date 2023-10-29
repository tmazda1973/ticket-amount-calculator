require_relative '../app_presenter'

module TicketAmountCalculator
  #
  # チケットの販売金額を計算するプレゼンターです。
  #
  class CalculatePresenter < AppPresenter
    attr_accessor \
      :adult_ticket_count, # チケット枚数（大人）
      :child_ticket_count, # チケット枚数（子供）
      :senior_ticket_count, # チケット枚数（シニア）
      :special_condition, # 特別条件
      :total_amount, # 販売合計金額
      :before_change_total_amount, # 金額変更前合計金額
      :change_amount_detail # 金額変更明細

    # @implements AppPresenter#output
    def output
      puts "販売合計金額：#{total_amount} 円"
      puts "金額変更前合計金額：#{before_change_total_amount} 円"
      puts "金額変更明細：#{change_amount_detail}"
    end
  end
end
