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
      # 出力用の値を構築する
      price_hash = self._build_output_price(self.ticket_type) # 単価
      count_hash = self._build_output_count(self.adult_ticket_count, self.child_ticket_count, self.senior_ticket_count) # 枚数
      amount_hash = self._build_output_amount(self.ticket_type, self.adult_ticket_count, self.child_ticket_count, self.senior_ticket_count) # 合計金額
      total_amount_hash = self._build_output_total_amount(self.before_change_total_amount, self.total_amount) # 合計金額
      # 計算結果を出力する
      @cli.echo_hr
      @cli.say("大人  ：#{price_hash[:adult]} 円 x #{count_hash[:adult]} 枚 = #{amount_hash[:adult]} 円")
      @cli.say("子供  ：#{price_hash[:child]} 円 x #{count_hash[:child]} 枚 = #{amount_hash[:child]} 円")
      @cli.say("シニア：#{price_hash[:senior]} 円 x #{count_hash[:senior]} 枚 = #{amount_hash[:senior]} 円")
      @cli.say("")
      @cli.say("金額変更前合計金額：")
      @cli.say(" #{total_amount_hash[:before]} 円")
      @cli.say("販売合計金額：")
      @cli.say(" #{total_amount_hash[:after]} 円")
      @cli.say("")
      @cli.say("金額変更明細：")
      @cli.say("#{self.change_amount_detail}") if (!self.change_amount_detail.nil? && !self.change_amount_detail.empty?)
      @cli.echo_hr
    end

    private
    #
    # 出力用の合計金額情報を構築します。
    # @param before_amount [Integer,BigDecimal] 金額変更前合計金額
    # @param after_amount [Integer,BigDecimal] 販売合計金額
    # @return [Hash<Symbol>] 出力用の合計金額情報
    # @private
    #
    def _build_output_total_amount(before_amount , after_amount)
      before = self.number_format(before_amount)
      after = self.number_format(after_amount)
      max_len = [before.length, after.length].max
      {
        before: before.rjust(max_len),
        after: after.rjust(max_len)
      }
    end

    #
    # 出力用の単価情報を構築します。
    # @param ticket_type [Integer] チケット種別
    # @return [Hash<Symbol>] 出力用の単価情報
    # @private
    #
    def _build_output_price(ticket_type)
      adult = self.number_format(self.adult_ticket_price(ticket_type))
      child = self.number_format(self.child_ticket_price(ticket_type))
      senior = self.number_format(self.senior_ticket_price(ticket_type))
      max_len = [adult.length, child.length, senior.length].max
      {
        adult: adult.rjust(max_len),
        child: child.rjust(max_len),
        senior: senior.rjust(max_len)
      }
    end

    #
    # 出力用の枚数情報を構築します。
    # @param adult_count [Integer] 大人の枚数
    # @param child_count [Integer] 子供の枚数
    # @param senior_count [Integer] シニアの枚数
    # @return [Hash<Symbol>] 出力用の枚数情報
    # @private
    #
    def _build_output_count(adult_count, child_count, senior_count)
      adult = self.number_format(adult_count)
      child = self.number_format(child_count)
      senior = self.number_format(senior_count)
      max_len = [adult.length, child.length, senior.length].max
      {
        adult: adult.rjust(max_len),
        child: child.rjust(max_len),
        senior: senior.rjust(max_len)
      }
    end

    #
    # 出力用の合計金額情報を構築します。
    # @param ticket_type [Integer] チケット種別
    # @param adult_count [Integer] 大人の枚数
    # @param child_count [Integer] 子供の枚数
    # @param senior_count [Integer] シニアの枚数
    # @return [Hash<Symbol>] 出力用の合計金額情報
    # @private
    #
    def _build_output_amount(ticket_type, adult_count, child_count, senior_count)
      adult = self.number_format(self.calc_adult_ticket_amount(ticket_type, adult_count))
      child = self.number_format(self.calc_child_ticket_amount(ticket_type, child_count))
      senior = self.number_format(self.calc_senior_ticket_amount(ticket_type, senior_count))
      max_len = [adult.length, child.length, senior.length].max
      {
        adult: adult.rjust(max_len),
        child: child.rjust(max_len),
        senior: senior.rjust(max_len)
      }
    end
  end
end
