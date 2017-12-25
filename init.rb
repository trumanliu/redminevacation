Redmine::Plugin.register :ingeekvacation do
  name 'Ingeekvacation plugin'
  author 'truman'
  description 'a vacation management plugin'
  version '0.0.1'
  url 'https://github.com/trumanliu/ingeekvacation'
  author_url 'trumanliu.com'

  permission :休假管理, :vacation => :index
  menu :top_menu, :vacation, { :controller => 'vacation', :action => 
  'index' }, :caption => '休假申请' 

end
