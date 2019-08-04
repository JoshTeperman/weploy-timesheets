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
    if params[:timesheet]['date(1i)'].present?
      params[:date] = parse_date
      params[:start_time] = parse_start_time
      params[:end_time] = parse_end_time
    end

    @timesheet = Timesheet.create(timesheet_params)

    if @timesheet.valid?
      flash[:success] = 'created a new timesheet'
      redirect_to :index
    else
      flash[:errors] = @timesheet.errors.full_messages
      redirect_to new_timesheet_path
    end
  end

  def update
    @timesheet = Timesheet.find(params[:id])
  end

  def destroy
    Timesheet.destroy(params[:id])
  end

  private

  def parse_date
    year = params[:timesheet]['date(1i)']
    month = params[:timesheet]['date(2i)']
    day = params[:timesheet]['date(3i)']
    Date.new(year.to_i, month.to_i, day.to_i)
  end

  def  parse_start_time
    start_time_hour = params[:timesheet]['start_time(4i)']
    start_time_minute = params[:timesheet]['start_time(5i)']
    Time.zone.parse("#{start_time_hour}:#{start_time_minute}")
  end

  def parse_end_time
    end_time_hour = params[:timesheet]['end_time(4i)']
    end_time_minute = params[:timesheet]['end_time(5i)']
    Time.zone.parse("#{end_time_hour}:#{end_time_minute}")
  end

  def timesheet_params
    params.permit(:date, :start_time, :end_time)
  end
end
