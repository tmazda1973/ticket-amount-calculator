require 'thor'
require_relative '../../use_cases/ticket_amount/calculate_use_case'
require_relative '../../presenters/ticker_amount/calculate_presenter'
require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../helpers/cli_helper'
require_relative './input_receipt_operator'

module TicketAmount
  #
  # チケットの販売金額に関するコマンド群です。
  #
  class CLI < Thor
    include CLIHelper

    attr_accessor \
      :adult_ticket_count,
      :child_ticket_count,
      :senior_ticket_count,
      :special_conditions

    class << self
      #
      # エラー発生時にコマンドを終了するかを判定します。
      # @return [Boolean] true 終了する, false 終了しない
      # @classmethod
      #
      def exit_on_failure?
        true
      end
    end

    default_command :calculate
    desc 'calculate', 'チケットの販売金額を計算します。'
    method_option :type,
      aliases: 't',
      type: :numeric,
      desc: '販売種別',
      enum: TicketType::all,
      lazy_default: TicketType::NORMAL,
      banner: '1:通常, 2:特別'
    def calculate
      presenter = CalculatePresenter.new(self)
      presenter.ticket_type = options[:type] || TicketType::NORMAL # 販売種別
      self.echo_hr
      self.say("チケットの販売金額を計算します。")
      self.say("")
      self.say("販売種別を指定する場合、[-t 1:通常, 2:特別] を指定してください。（デフォルト: 1:通常）")
      self.say("Usage:")
      self.say("  exe/ticket_amount.rb [-t 1:通常, 2:特別]")
      self.say("")
      self.say("(中断: [Q|q])")
      self.echo_hr
      self.say("販売種別: #{TicketType::name(presenter.ticket_type)}")
      # 対話形式で入力を受け付ける
      InputReceiptOperator.new(self).start
      presenter.adult_ticket_count = self.adult_ticket_count # チケット枚数（大人）
      presenter.child_ticket_count = self.child_ticket_count # チケット枚数（子供）
      presenter.senior_ticket_count = self.senior_ticket_count # チケット枚数（シニア）
      presenter.special_conditions = self.special_conditions # 特別条件
      CalculateUseCase.call(presenter)
      presenter.output
    end
  end
end
