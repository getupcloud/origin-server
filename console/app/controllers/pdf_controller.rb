class PdfController < ConsoleController
  include Console::UserManagerHelper

  def as_pdf

  end

  def show
    id = params[:id]
    result = user_manager_billing_invoice_pdf(id)
    send_data result.body,
      :type => 'application/pdf',
      :disposition => "attachment; filename=GetupCloud - Fatura #{id}.pdf"
  end
end
