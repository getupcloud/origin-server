class AddressPrimaryController < AddressController

  def edit
    edit_address :primary
  end

  def create
    create_address :primary
  end
end
