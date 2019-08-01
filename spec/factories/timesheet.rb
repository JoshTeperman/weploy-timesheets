FactoryBot.define do
  factory :timesheet do
    date { Date.current }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :monday_timesheet do
    date { Date.new(2019, 7, 1) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end
  
  factory :tuesday_timesheet do
    date { Date.new(2019, 7, 2) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :wednesday_timesheet do
    date { Date.new(2019, 7, 3) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :thursday_timesheet do
    date { Date.new(2019, 7, 4) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :friday_timesheet do
    date { Date.new(2019, 7, 5) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :saturday_timesheet do
    date { Date.new(2019, 7, 6) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end

  factory :sunday_timesheet do
    date { Date.new(2019, 7, 7) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end
end