Rails.application.routes.draw do
  scope "/broker/rest" do
    constraints(:ip => %r(127.0.\d+.\d+)) do
      resource :accounts, :only => [:create], :controller => :account
    end
  end
end
