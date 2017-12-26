class VacationController < ApplicationController
  unloadable


  def index
    require_login || return
    @crnt_uid = User.current.id
    #@this_uid = (params.key?(:user) && User.current.allowed_to?(:view_work_time_other_member, @project)) ? params[:user].to_i : @crnt_uid
    #@this_user = User.find_by_id(@this_uid)
    #@vactions = Vacation.all;
    @vacation = Vacation.new();

  end



end
