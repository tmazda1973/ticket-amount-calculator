require 'thor'
require_relative '../../use_cases/ticket_amount/calculate_use_case'
require_relative '../../enums/ticket_amount/ticket_type'

module TicketAmount
  #
  # チケットの販売金額に関するコマンド群です。
  #
  class CLI < Thor
    desc 'calculate', 'チケットの販売金額を計算します。'
    method_option :type, type: :numeric, desc: '販売種別', banner: '1:通常(デフォルト), 2:特別'
    def calculate
      presenter = CalculatePresenter.new
      presenter.ticket_type = options[:type] || TicketType::NORMAL # 販売種別
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
      prompt = 'チケット枚数(大人): '
      error_message = '入力値に誤りがあります。再入力してください。'
      input = ask(prompt)
      until input =~ /^[0-9]+$/
        print error_message
        input = ask(prompt)
      end
      input
    end

    #
    # チケット枚数（子供）の入力を受け付けます。
    # @return [Integer] チケット枚数（子供）
    # @private
    #
    def _input_child_ticket_count
      prompt = 'チケット枚数(子供): '
      error_message = '入力値に誤りがあります。再入力してください。'
      input = ask(prompt)
      until input =~ /^[0-9]+$/
        print error_message
        input = ask(prompt)
      end
      input
    end

    #
    # チケット枚数（シニア）の入力を受け付けます。
    # @return [Integer] チケット枚数（シニア）
    # @private
    #
    def _input_senior_ticket_count
      prompt = 'チケット枚数(シニア): '
      error_message = '入力値に誤りがあります。再入力してください。'
      input = ask(prompt)
      until input =~ /^[0-9]+$/
        print error_message
        input = ask(prompt)
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
