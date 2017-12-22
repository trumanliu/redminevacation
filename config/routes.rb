RedmineApp::Application.routes.draw do
    match 'vacation/:action', :to => 'vacation#index', :via => [:get, :post]
    match 'vacation/:action/:id', :to => 'vacation#list', :via => [:get, :post]
  end
