class VacationController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index,:audit]
  before_action :set_vacation, only: [:show, :edit, :update, :destroy,:auditpass]
  include CustomFieldsHelper
  def new
    @vacation = Vacation.new();
    @users = User.all

  end

  def index
    curt_uid = User.current.id
    @vacations = Vacation.where(applyId: curt_uid)
  end

  def audit
    curt_uid = User.current.id
    @vacations = Vacation.where(auditId: curt_uid, statusShow: '待审批')
    @time_logs = TimeEntry.where(audit_id: curt_uid, audit_status: '待审核')
  end
  def auditpass
    @vacation.update_attribute(:statusShow,'审批通过')
    curt_uid = User.current.id
    @vacations = Vacation.where(auditId: curt_uid, statusShow: '待审批')
    @time_logs = TimeEntry.where(audit_id: curt_uid, audit_status: '待审核')
    render :audit
  end

  def auditpasstime
    curt_uid = User.current.id
    @timelog = TimeEntry.find_by(id: params[:id])
    @timelog.update_attribute(:audit_status,'审批通过')
    @vacations = Vacation.where(auditId: curt_uid, statusShow: '待审批')
    @time_logs = TimeEntry.where(audit_id: curt_uid, audit_status: '待审核')
    render :audit
  end

  def create 
    @vacation = Vacation.new(vacation_params)
    @vacation.applyId = User.current.id
    @vacation.applyName = User.current.name
    @vacation.statusShow = '待审批'
    @vacation.auditName = User.find_by(id: @vacation.auditId).name
    respond_to do |format|
      if @vacation.save
        format.html { redirect_to @vacation, notice: '休假申请已提交.' }
        format.json { render :show, status: :created, location: @vacation }
      else
        format.html { render :new }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
      end
      format.js
    end
  end

  def edit
    @users = User.all
  end
 
  def destroy
    @vacation.destroy
    @vacations = Vacation.all
    respond_to do |format|
      format.html { redirect_to action: :index, notice: '休假申请已删除.' }
      format.js
    end
  end

  def show
    @users = User.all
  end

  def update
    @vacation.auditName = User.find_by(id: @vacation.auditId).name
    respond_to do |format|
      if @vacation.update(vacation_params)
        format.html { redirect_to @vacation, notice: '休假申请已更新.' }
        format.json { render :show, status: :updated, location: @vacation }
      else
        format.html { render :edit }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
      end
      format.js
    end
  end

  

  private
    def set_vacation
      @vacation = Vacation.find_by(id: params[:id])
    end

    def vacation_params
      params.require(:vacation).permit!
    end
end
