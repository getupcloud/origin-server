module Console::CreditCardHelper
  @@credit_card_list = [
     ['...', ''],
     ['Visa', 'visa'],
     ['MasterCard', 'mastercard'],
     ['American Express', 'amex'],
     ['Diners Club', 'dinersclubintl']
    ]

  def credit_card_list
    @@credit_card_list
  end

  # Hash[code => name]
  @@credit_card_hash = Hash[*@@credit_card_list.map{|c| [ c[1], c[0] ]}.flatten]
  def credit_card_name(code)
    @@credit_card_hash[code]
  end
end
