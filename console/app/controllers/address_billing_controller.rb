class AddressBillingController < AddressController

  def edit
    edit_address :billing
  end

  def create
    create_address :billing
  end
end
