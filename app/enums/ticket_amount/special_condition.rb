module TicketAmount
  #
  # チケット販売の特別条件を表す列挙型です。
  #
  module SpecialCondition
    EVENING = 1 # 夕方料金
    HOLIDAY = 2 # 休日料金
    MON_WED = 3 # 月水割引

    # 論理名
    ENUM_NAMES = {
      EVENING => '夕方料金',
      HOLIDAY => '休日料金',
      MON_WED => '月水割引'
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
      # @param [SpecialCondition,Integer] value 列挙値
      # @return [String] 論理名
      # @classmethod
      #
      def name(value)
        ENUM_NAMES[value]
      end
    end
  end
end
