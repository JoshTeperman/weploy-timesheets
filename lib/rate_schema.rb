class RateSchema
  attr_reader :base_rate, :overtime_rate, :start_time, :end_time
  def initialize(overtime_rate: nil, base_rate:, start_time:, end_time:)
    @base_rate = base_rate
    @start_time = start_time
    @end_time = end_time
    @overtime_rate = overtime_rate
  end
end

mon_wed_fri_schema = RateSchema.new(
  base_rate: 22.0,
  start_time: Time.zone.parse('7:00'),
  end_time: Time.zone.parse('19:00'),
  overtime_rate: 33.0
)

tues_thurs_schema = RateSchema.new(
  base_rate: 25.0,
  start_time: Time.zone.parse('5:00'),
  end_time: Time.zone.parse('17:00'),
  overtime_rate: 35.0
)

weekend_schema = RateSchema.new(
  base_rate: 47.0,
  start_time: Time.zone.parse('5:00'),
  end_time: Time.zone.parse('17:00'),
)

RATE_SCHEMA = {
  'Monday': mon_wed_fri_schema,
  'Tuesday': tues_thurs_schema,
  'Wednesday': mon_wed_fri_schema,
  'Thursday': tues_thurs_schema,
  'Friday': mon_wed_fri_schema,
  'Saturday': weekend_schema,
  'Sunday': weekend_schema
}
