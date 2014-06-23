module Console::BillingHelper
  def item_price(item, prices)
    usage_type = item[:usage_type]
    gear_size = item[:gear_size]
    gear_price(usage_type, gear_size, prices)
  end

  def gear_price(usage_type, gear_size, prices)
    prices.select{ |p| p if p[:item] == usage_type.to_s and p[:gear_size] == gear_size.to_s and p[:currency] == 'BRL' }.first
  end

  def has_service(services)
    services.length > 0
  end

  def has_bonus(amount)
    amount[:GEAR_USAGE][:bonus][:amount].to_f > 0 rescue false
  end

  def has_credit(amount)
    amount[:GEAR_USAGE][:credit][:amount].to_f > 0 rescue false
  end
end
