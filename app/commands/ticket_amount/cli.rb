require 'thor'
require_relative '../../use_cases/ticket_amount/calculate_use_case'
require_relative '../../presenters/ticker_amount/calculate_presenter'
require_relative '../../enums/ticket_amount/ticket_type'

module TicketAmount
  #
  # チケットの販売金額に関するコマンド群です。
  #
  class CLI < Thor
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

    desc 'calculate', 'チケットの販売金額を計算します。'
    method_option :type, type: :numeric, desc: '販売種別', required: true, banner: '1:通常, 2:特別'
    def calculate
      presenter = CalculatePresenter.new
      presenter.ticket_type = options[:type] || TicketType::NORMAL # 販売種別
      puts "販売種別: #{TicketType::name(presenter.ticket_type)}"
      # 対話形式で入力を受け付ける
      presenter.adult_ticket_count = self._input_adult_ticket_count # チケット枚数（大人）
      presenter.child_ticket_count = self._input_child_ticket_count # チケット枚数（子供）
      presenter.senior_ticket_count = self._input_senior_ticket_count # チケット枚数（シニア）
      presenter.special_conditions = self._input_special_conditions # 特別条件
      CalculateUseCase.call(presenter)
      presenter.output
    end

    private
    #
    # チケット枚数（大人）の入力を受け付けます。
    # @return [Integer] チケット枚数（大人）
    # @private
    #
    def _input_adult_ticket_count
      prompt = 'チケット枚数(大人) [数字]:'
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = ask(prompt)
      until input =~ /^[1-9]\d*$/
        puts error_message
        input = ask(prompt)
        exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # チケット枚数（子供）の入力を受け付けます。
    # @return [Integer] チケット枚数（子供）
    # @private
    #
    def _input_child_ticket_count
      prompt = 'チケット枚数(子供) [数字]:'
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = ask(prompt)
      until input =~ /^[1-9]\d*$/
        puts error_message
        input = ask(prompt)
        exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # チケット枚数（シニア）の入力を受け付けます。
    # @return [Integer] チケット枚数（シニア）
    # @private
    #
    def _input_senior_ticket_count
      prompt = 'チケット枚数(シニア) [数字]: '
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = ask(prompt)
      until input =~ /^[1-9]\d*$/
        puts error_message
        input = ask(prompt)
        exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # 特別条件の入力を受け付けます。
    # @return [Array] 特別条件
    # @private
    #
    def _input_special_conditions
      value = []
      value
    end
  end
end
