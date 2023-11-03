module TicketAmount
  #
  # チケット種別を表す列挙型です。
  #
  module TicketType
    NORMAL = 1 # 通常
    SPECIAL = 2 # 特別

    # 論理名
    ENUM_NAMES = {
      NORMAL => '通常',
      SPECIAL => '特別',
    }.freeze
    private_constant :ENUM_NAMES

    class << self
      #
      # 全ての列挙値を取得します。
      # @return [Array<Integer>] 全ての列挙値
      # @classmethod
      #
      def all
        self.constants.map{|name| self.const_get(name) }
      end

      #
      # 列挙値の論理名を取得します。
      # @param [TicketType,Integer] value 列挙値
      # @return [String] 論理名
      # @classmethod
      #
      def name(value)
        ENUM_NAMES[value]
      end
    end
  end
end
