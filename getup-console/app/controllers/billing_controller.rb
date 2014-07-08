class BillingController < ConsoleController
  include Console::BillingHelper
  include Console::UserManagerHelper
  include Console::CountryHelper

  def index
      result  = user_manager_billing_history.content
      data = result[:data][0]
      @currency = data[:payment_data].nil? ? '' : data[:payment_data][:currency]
      @history  = data[:history].sort_by{|h| h[:ref_date]}.reverse
  end

  def show
    id = params[:id]

    begin
      result = user_manager_billing_invoice(id).content
      raise result[:data][0] if result[:status] != 'ok'
    rescue Exception => e
      return redirect_to billing_index_path, :flash => {:error => e.message}
    end

    @status = result ? true : false

    if @status
      result        = result[:data][0]
      @id           = id
      @amount       = result[:invoice][:amount]
      @period       = result[:invoice][:period]
      @payment      = result[:invoice][:payment_data]
      @getup        = result[:invoice][:getup]
      @user         = result[:invoice][:user]
      @address      = result[:invoice][:billing_address]
      @applications = result[:invoice][:applications]
      @services     = result[:invoice][:services]
      if result[:invoice].has_key? :prices
        @prices       = result[:invoice][:prices]
      else
        @prices       = user_manager_subscription_prices.content
      end

      # compat
      @user[:billing_type] = 'Variable' unless @user.has_key? :billing_type
      if @prices.kind_of?(Hash)
        prices = []
        @prices.each{ |currency, item|
            if item.kind_of?(Hash)
              item.each{ |item_name, value|
                price = Hash[value]
                price[:item] = item_name.to_s
                price[:gear_size] = item_name == 'ADDTL_FS_GB' ? "" : "small"
                price[:cart_name] = ""
                prices << price
              }
            else
                prices.concat(item)
            end
          @prices = prices
        }
      end

      @acronym      = @prices.select{|i| i if i[:item]=="GEAR_USAGE" and i[:currency]=='BRL' }.first[:acronym]
      @unit         = {'h' => I18n.t(:hour), 'd' => I18n.t(:day), 'm' => I18n.t(:month), 'y' => I18n.t(:year), 'g' => 'gigabyte'}

      @getup[:country_name]   = country_name(@getup[:country_code])
      @address[:country_name] = country_name(@address[:country_code])
    end
  end
end
