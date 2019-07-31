class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def show
    @timesheet = Timesheet.find(params[:id])
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.create(timesheet_params)
  end

  def update
    @timesheet = Timesheet.find(params[:id])
  end

  def destroy
    Timesheet.destroy(params[:id])
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:date, :start_time, :end_time, :amount)
  end
end
