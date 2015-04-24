module Console::ConsoleHelper

  #FIXME: Replace with real isolation of login state
  def logout_path
    signout_path
  end

  def outage_notification
  end

  def product_branding
    [
      image_tag(Console.config.env(:PRODUCT_LOGO, "/assets/logo-origin.png"), :alt => Console.config.env(:PRODUCT_TITLE, "Getup OpenShift"))
    ].join.html_safe
  end

  def product_title
    Console.config.env(:PRODUCT_TITLE, 'Getup OpenShift')
  end
end
