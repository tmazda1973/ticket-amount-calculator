module TicketAmountCalculator
  #
  # チケットの販売金額に関する定数を定義するモジュールです。
  #
  module TicketAmountConst
    ADULT_TICKET_PRICE = 1000 # 大人料金
    ADULT_TICKET_PRICE_SPECIAL = 600 # 大人料金（特別）
    CHILD_TICKET_PRICE = 500 # 子供料金
    CHILD_TICKET_PRICE_SPECIAL = 400 # 子供料金（特別）
    SENIOR_TICKET_PRICE = 800 # シニア料金
    SENIOR_TICKET_PRICE_SPECIAL = 500 # シニア料金（特別）
    HOLIDAY_EXTRA_PRICE = 200 # 休日割増料金
    CHILD_TICKET_WEIGHT = 0.5 # 子供料金チケットの重み
    GROUP_DISCOUNT_RATE = 0.9 # 団体割引率
    GROUP_DISCOUNT_THRESHOLD = 10 # 団体割引の適用基準人数
  end
end
