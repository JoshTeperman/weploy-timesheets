module TimesheetsHelper
  def fetch_day(timesheet)
    timesheet.date.strftime('%A')
  end

  
end
