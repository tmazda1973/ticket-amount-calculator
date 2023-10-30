require_relative '../app_presenter'
require_relative '../../helpers/ticket_amount/ticket_amount_helper'

module TicketAmount
  #
  # チケットの販売金額を計算するプレゼンターです。
  #
  class CalculatePresenter < AppPresenter
    include TicketAmountHelper

    attr_accessor \
      :ticket_type, # チケット種別
      :adult_ticket_count, # チケット枚数（大人）
      :child_ticket_count, # チケット枚数（子供）
      :senior_ticket_count, # チケット枚数（シニア）
      :special_conditions, # 特別条件
      :total_amount, # 販売合計金額
      :before_change_total_amount, # 金額変更前合計金額
      :change_amount_detail # 金額変更明細

    #
    # コンストラクタ
    # @param cli [TicketAmount::CLI] コマンドラインインターフェース
    #
    def initialize(cli)
      @cli = cli
    end

    # @implements AppPresenter#output
    def output
      @cli.echo_hr
      @cli.say("大人：#{self.adult_ticket_price(self.ticket_type)} x #{self.adult_ticket_count} = #{self.calc_adult_ticket_amount(self.ticket_type, self.adult_ticket_count)} 円")
      @cli.say("子供：#{self.child_ticket_price(self.ticket_type)} x #{self.child_ticket_count} = #{self.calc_child_ticket_amount(self.ticket_type, self.child_ticket_count)} 円")
      @cli.say("シニア：#{self.senior_ticket_price(self.ticket_type)} x #{self.senior_ticket_count} = #{self.calc_senior_ticket_amount(self.ticket_type, self.senior_ticket_count)} 円")
      @cli.say("販売合計金額：#{self.total_amount} 円")
      @cli.say("金額変更前合計金額：#{self.before_change_total_amount} 円")
      @cli.say("金額変更明細：#{self.change_amount_detail}")
      @cli.echo_hr
    end
  end
end
