RedmineApp::Application.routes.draw do
  match 'vacation/audit', :to => 'vacation#audit', :via => [:get, :post]
  match 'vacation/aduit/:id', :to => 'vacation#audit', :via => [:get, :post]
  match 'vacation/auditpass', :to => 'vacation#auditpass', :via => [:get, :post]
  match 'vacation/aduitpass/:id', :to => 'vacation#auditpass', :via => [:get, :post]
  resources :vacation
end
