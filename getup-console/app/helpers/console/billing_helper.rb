module Console::BillingHelper
  def item_price(item, prices)
    usage_type = item[:usage_type]
    if usage_type == 'ADDTL_FS_GB'
      gear_size = ''
    else
      gear_size = item[:gear_size] ? item[:gear_size] : 'small'
    end
    gear_price(usage_type, gear_size, prices, item[:currency] ? item[:currency] : 'BRL')
  end

  def gear_price(usage_type, gear_size, prices, currency='BRL')
    prices.select{ |p| p if p[:item] == usage_type.to_s and p[:gear_size] == gear_size.to_s and p[:currency] == currency }.first
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
