class CreditCardController < ConsoleController
  include Console::UserManagerHelper

  def new
  end

  def create
    card_hash = params['card_hash']
    result = user_manager_subscription_create('creditcard')

    if result.code === 302
      redirect_to account_path, :flash => {:success => I18n.t('Conta atualizada com sucesso')}
    else
      redirect_to account_path, :flash => {:error => result.content[:message]}
    end
  end
end
