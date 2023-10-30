require_relative '../app_presenter'
require_relative '../../value_objects/ticket_amount/ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'

module TicketAmount
  #
  # チケットの販売金額を計算するプレゼンターです。
  #
  class CalculatePresenter < AppPresenter
    include TicketAmountConst

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
      @cli.say("大人：#{self._adult_ticket_price(self.ticket_type)} x #{self.adult_ticket_count} = #{self._calc_adult_ticket_amount(self.ticket_type, self.adult_ticket_count)} 円")
      @cli.say("子供：#{self._child_ticket_price(self.ticket_type)} x #{self.child_ticket_count} = #{self._calc_child_ticket_amount(self.ticket_type, self.child_ticket_count)} 円")
      @cli.say("シニア：#{self._senior_ticket_price(self.ticket_type)} x #{self.senior_ticket_count} = #{self._calc_senior_ticket_amount(self.ticket_type, self.senior_ticket_count)} 円")
      @cli.say("販売合計金額：#{self.total_amount} 円")
      @cli.say("金額変更前合計金額：#{self.before_change_total_amount} 円")
      @cli.say("金額変更明細：#{self.change_amount_detail}")
      @cli.echo_hr
    end

    private
    #
    # チケット(大人)の単価を取得します。
    # @param ticket_type [Integer] チケット種別
    # @return [Integer,BigDecimal] 単価
    # @private
    #
    def _adult_ticket_price(ticket_type)
      if ticket_type === TicketType::SPECIAL
        ADULT_TICKET_PRICE_SPECIAL
      else
        ADULT_TICKET_PRICE
      end
    end

    #
    # チケット(大人)の合計金額を算出します。
    # @param ticket_type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    # @private
    #
    def _calc_adult_ticket_amount(ticket_type, count)
      self._adult_ticket_price(ticket_type) * count
    end

    #
    # チケット(子供)の単価を取得します。
    # @param ticket_type [Integer] チケット種別
    # @return [Integer,BigDecimal] 単価
    # @private
    #
    def _child_ticket_price(ticket_type)
      if ticket_type === TicketType::SPECIAL
        CHILD_TICKET_PRICE_SPECIAL
      else
        CHILD_TICKET_PRICE
      end
    end

    #
    # チケット(子供)の合計金額を算出します。
    # @param ticket_type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    # @private
    #
    def _calc_child_ticket_amount(ticket_type, count)
      self._child_ticket_price(ticket_type) * count
    end

    #
    # チケット(シニア)の単価を取得します。
    # @param ticket_type [Integer] チケット種別
    # @return [Integer,BigDecimal] チケット単価
    # @private
    #
    def _senior_ticket_price(ticket_type)
      if ticket_type === TicketType::SPECIAL
        SENIOR_TICKET_PRICE_SPECIAL
      else
        SENIOR_TICKET_PRICE
      end
    end

    #
    # チケット(シニア)の合計金額を算出します。
    # @param ticket_type [Integer] チケット種別
    # @param count [Integer] チケット枚数
    # @return [Integer,BigDecimal] 合計金額
    # @private
    #
    def _calc_senior_ticket_amount(ticket_type, count)
      self._senior_ticket_price(ticket_type) * count
    end
  end
end
