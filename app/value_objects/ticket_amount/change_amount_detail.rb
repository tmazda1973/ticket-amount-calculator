require_relative '../../constants/ticket_amount/ticket_amount_const'
require_relative '../../enums/ticket_amount/ticket_type'
require_relative '../../enums/ticket_amount/special_condition'
require_relative '../../helpers/ticket_amount/ticket_amount_helper'
require_relative '../../helpers/cli_helper'

module TicketAmount
  #
  # 金額変更明細の値オブジェクトです。
  #
  class ChangeAmountDetail
    include TicketAmountConst
    include CLIHelper
    include TicketAmountHelper

    #
    # コンストラクタ
    # @param [TicketType,Integer] ticket_type チケット種別
    # @param [Integer] adult_ticket_count チケット枚数（大人）
    # @param [Integer] child_ticket_count チケット枚数（子供）
    # @param [Integer] senior_ticket_count チケット枚数（シニア）
    # @param [Array<SpecialCondition>] special_conditions 特別条件
    #
    def initialize(
      ticket_type: TicketType::NORMAL,
      adult_ticket_count: 0,
      child_ticket_count: 0,
      senior_ticket_count: 0,
      special_conditions: []
    )
      @ticket_type = ticket_type
      @adult_count = adult_ticket_count
      @child_count = child_ticket_count
      @senior_count = senior_ticket_count
      @special_conditions = special_conditions
    end

    #
    # 金額変更明細を取得します。
    # @return [Array<String>] 金額変更明細
    #
    def value
      details = [] # 金額変更明細
      # 団体割引が適用されている
      holder = self.build_ticket_count_holder(@adult_count, @child_count, @senior_count)
      total_count = holder.adult + holder.child + holder.senior
      if self.group_discount?(holder)
        details << '団体割引: 10％割引'
      end
      # 特別条件が適用されている
      special = self._build_special_detail(total_count) # 特別条件の詳細データ
      # 夕方料金
      if @special_conditions.include?(SpecialCondition::EVENING)
        _name = special[:evening][:name]
        _price = special[:evening][:price].rjust(special[:price_max_len])
        _total_count = special[:evening][:total_count].rjust(special[:total_count_max_len])
        _total_price = special[:evening][:total_price].rjust(special[:total_price_max_len])
        details << "#{_name}: #{_price}円割引 (#{_price} 円 x #{_total_count} 枚) = - #{_total_price} 円)"
      end
      # 休日料金
      if @special_conditions.include?(SpecialCondition::HOLIDAY)
        _name = special[:holiday][:name]
        _price = special[:holiday][:price].rjust(special[:price_max_len])
        _total_count = special[:holiday][:total_count].rjust(special[:total_count_max_len])
        _total_price = special[:holiday][:total_price].rjust(special[:total_price_max_len])
        details << "#{_name}: #{_price}円増   (#{_price} 円 x #{_total_count} 枚) = + #{_total_price} 円)"
      end
      # 月水割引
      if @special_conditions.include?(SpecialCondition::MON_WED)
        _name = special[:mon_wed][:name]
        _price = special[:mon_wed][:price].rjust(special[:price_max_len])
        _total_count = special[:mon_wed][:total_count].rjust(special[:total_count_max_len])
        _total_price = special[:mon_wed][:total_price].rjust(special[:total_price_max_len])
        details << "#{_name}: #{_price}円割引 (#{_price} 円 x #{_total_count} 枚) = - #{_total_price} 円)"
      end
      details
    end

    private
    #
    # 金額変更明細データを構築します。
    # @param special_condition [Integer,SpecialCondition] 特別条件
    # @param total_count [Integer] チケット枚数
    # @param price [Integer] 金額
    # @return [Hash<Symbol>] 金額変更明細データ
    # @private
    #
    def _build_change_amount_detail(special_condition, total_count, price)
      {
        name: SpecialCondition::name(special_condition),
        price: self.number_format(price),
        total_count: self.number_format(total_count),
        total_price: self.number_format(price * total_count)
      }
    end

    #
    # 特別条件の詳細データを構築します。
    # @param total_count [Integer] チケット枚数
    # @return [Hash<Symbol>] 特別条件の詳細データ
    # @private
    #
    def _build_special_detail(total_count)
      evening = self._build_change_amount_detail(SpecialCondition::EVENING, total_count, EVENING_DISCOUNT_PRICE) # 夕方料金
      holiday = self._build_change_amount_detail(SpecialCondition::HOLIDAY, total_count, HOLIDAY_EXTRA_PRICE) # 休日料金
      mon_wed = self._build_change_amount_detail(SpecialCondition::MON_WED, total_count, MON_WED_DISCOUNT_PRICE) # 月水割引
      {
        evening: evening,
        holiday: holiday,
        mon_wed: mon_wed,
        price_max_len: [evening[:price].length, holiday[:price].length, mon_wed[:price].length].max,
        total_count_max_len: [evening[:total_count].length, holiday[:total_count].length, mon_wed[:total_count].length].max,
        total_price_max_len: [evening[:total_price].length, holiday[:total_price].length, mon_wed[:total_price].length].max
      }
    end
  end
end
