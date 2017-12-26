class Vacation < ActiveRecord::Base
  attr_accessible :end, :reason, :start
end
