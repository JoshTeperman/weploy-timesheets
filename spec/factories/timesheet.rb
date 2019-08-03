FactoryBot.define do
  factory :timesheet do
    date { Date.new(2019, 7, 1) }
    start_time { Time.zone.parse('9:00') }
    end_time { Time.zone.parse('18:00') }
  end
end

