FactoryBot.define do
  factory :timesheet do
    date { Date.current }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end
end