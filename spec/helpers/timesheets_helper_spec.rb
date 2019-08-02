require 'rails_helper'

RSpec.describe TimesheetsHelper, type: :helper do
  describe 'fetch_day method' do
    let(:monday_timesheet) { build(:timesheet, date: Date.new(2019, 7, 1)) }
    it 'returns Monday' do
      expect(fetch_day(monday_timesheet)).to eq('Monday')
    end

    let(:friday_timesheet) { build(:timesheet, date: Date.new(2019, 7, 5)) }
    it 'returns Friday' do
      expect(fetch_day(friday_timesheet)).to eq('Friday')
    end
  end
end
