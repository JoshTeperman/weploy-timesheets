puts 'Starting Seeding ...'
puts 'Deleting Timesheets ... '
Timesheet.destroy_all

timesheets = [
      {
      date: Date.new(2019, 7, 1),
      start_time: Time.zone.parse('07:00'),
      end_time: Time.zone.parse('17:00')
      },
      {
      date: Date.new(2019, 7, 2),
      start_time: Time.zone.parse('01:24'),
      end_time: Time.zone.parse('13:45')
      },
      {
      date: Date.new(2019, 7, 2),
      start_time: Time.zone.parse('19:00'),
      end_time: Time.zone.parse('21:30')
      },
      {
      date: Date.new(2019, 8, 1),
      start_time: Time.zone.parse('08:30'),
      end_time: Time.zone.parse('18:45')
      },
      {
      date: Date.new(2019, 8, 4),
      start_time: Time.zone.parse('10:00'),
      end_time: Time.zone.parse('21:01')
      }
]

puts 'Seeding Timesheets ...'
timesheets.each do |timesheet|
  new_timesheet = Timesheet.create(timesheet)
  p new_timesheet
end

puts 'Finished Seeding'
