class RestartsController < ConsoleController

  def show
    @application = Application.find(params[:application_id], :as => current_user)
  end

  def update
    @application = Application.find(params[:application_id], :as => current_user)

    if @application.restart!
      redirect_to @application, :flash => flash_messages(@application.messages, {:success => _("The application '%s' has been restarted") % @application.name})
    else
      render :show
    end
  end

end
