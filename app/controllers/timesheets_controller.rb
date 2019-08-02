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
    # begin
    #   @timesheet = Timesheet.new(timesheet_params)
    #   if @timesheet.save
    #     p 'saved'
    #     redirect_to :index
    #   else
    #     p 'couldnt save'
    #     @timesheet.errors.full_messages.each do |message|
    #       flash[:error] = message
    #     end
    #     render :new
    #   end
    # rescue => e
    #   p e.message
    # end
    @timesheet = Timesheet.create(timesheet_params)
    if @timesheet.valid?
      p @timesheet
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

  

  def timesheet_params
    params.permit(:date, :start_time, :end_time)
  end
end
