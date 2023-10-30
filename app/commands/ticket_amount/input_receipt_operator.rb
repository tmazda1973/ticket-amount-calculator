module TicketAmount
  #
  # CLIからの入力を制御するクラスです。
  #
  class InputReceiptOperator
    #
    # コンストラクタ
    # @param cli [Thor] コマンドラインインターフェース
    #
    def initialize(cli)
      @cli = cli
    end

    #
    # 処理を開始します。
    #
    def start
      @cli.adult_ticket_count = self._input_adult_ticket_count(@cli)
      @cli.child_ticket_count = self._input_child_ticket_count(@cli)
      @cli.senior_ticket_count = self._input_senior_ticket_count(@cli)
      @cli.special_conditions = self._input_special_conditions(@cli)
    end

    private
    #
    # チケット枚数（大人）の入力を受け付けます。
    # @param cli [Thor] コマンドラインインターフェース
    # @return [Integer] チケット枚数（大人）
    # @private
    #
    def _input_adult_ticket_count(cli)
      prompt = 'チケット枚数(大人) [数字]:'
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = cli.ask(prompt)
      until input =~ /^[1-9]\d*$/
        cli.say(error_message)
        input = cli.ask(prompt)
        cli.exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # チケット枚数（子供）の入力を受け付けます。
    # @param cli [Thor] コマンドラインインターフェース
    # @return [Integer] チケット枚数（子供）
    # @private
    #
    def _input_child_ticket_count(cli)
      prompt = 'チケット枚数(子供) [数字]:'
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = cli.ask(prompt)
      until input =~ /^[1-9]\d*$/
        cli.say(error_message)
        input = cli.ask(prompt)
        cli.exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # チケット枚数（シニア）の入力を受け付けます。
    # @param cli [Thor] コマンドラインインターフェース
    # @return [Integer] チケット枚数（シニア）
    # @private
    #
    def _input_senior_ticket_count(cli)
      prompt = 'チケット枚数(シニア) [数字]: '
      error_message = '入力値に誤りがあります。再入力してください。(コマンド終了: Q|q)'
      input = cli.ask(prompt)
      until input =~ /^[1-9]\d*$/
        cli.say(error_message)
        input = cli.ask(prompt)
        cli.exit(0) if input.downcase == 'q'
      end
      input
    end

    #
    # 特別条件の入力を受け付けます。
    # @param cli [Thor] コマンドラインインターフェース
    # @return [Array] 特別条件
    # @private
    #
    def _input_special_conditions(cli)
      value = []
      value
    end
  end
end
