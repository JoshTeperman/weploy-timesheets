require 'rails_helper'
require_relative '../../app/helpers/timesheets_helper'
require 'date'

RSpec.describe Timesheet, type: :model do
  before do
    Timesheet.destroy_all
  end

  let(:valid_timesheet) do
    create(:timesheet)
  end

  let(:mocks) do
    attributes_for(:timesheet)
  end

  describe 'Timesheet Model' do    

    it 'has a date' do
      expect(valid_timesheet.date.present?).to eq(true)
    end

    it 'has a start_time' do
      expect(valid_timesheet.start_time.present?).to eq(true)
    end

    it 'has an end_time' do
      expect(valid_timesheet.end_time.present?).to eq(true)
    end

    it 'has an amount' do
      expect(valid_timesheet.amount.present?).to eq(true)
    end

    it 'amount is a Float' do
      expect(valid_timesheet.amount.class).to eq(Float)
    end

    it 'is invalid when intialized without attributes' do
      expect(Timesheet.new).to be_invalid
    end

    it 'is valid with valid attributes' do
      expect(valid_timesheet).to be_valid
    end

    it 'is not valid without a date' do
      expect(Timesheet.new(
        start_time: mocks[:start_time],
        end_time: mocks[:end_time]
      )).to be_invalid
    end

    it 'is not valid without a start_time' do
      expect(Timesheet.new(
        date: mocks[:date],
        end_time: mocks[:end_time]
      )).to be_invalid
    end

    it 'is not valid without an end_time' do
      expect(Timesheet.new(
        date: mocks[:date],
        start_time: mocks[:start_time]
      )).to be_invalid
    end

    it 'is not valid when start_time is after end_time' do
      invalid_timesheet = build(:timesheet, start_time: Time.zone.parse('19:00'))
      expect(invalid_timesheet).to be_invalid
    end

    it 'is not valid when start_time is the same time as end_time' do
      invalid_timesheet = build(:timesheet, start_time: Time.zone.parse('18:00'))
      expect(invalid_timesheet).to be_invalid
    end

    describe 'Date cannot be in the future' do
      it 'is not valid when date is tomorrow' do
        timesheet_for_tomorrow = build(:timesheet, date: Date.current + 1)
        expect(timesheet_for_tomorrow).to be_invalid
      end

      it 'is valid when date is yesterday' do
        timesheet_for_yesterday = build(:timesheet, date: Date.current - 1)
        expect(timesheet_for_yesterday).to be_valid
      end
    end

    describe 'Timesheets cannot overlap' do
      it 'invalid when exactly the same timesheet' do
        create(:timesheet)
        overlapping_timesheet = build(:timesheet)
        expect(overlapping_timesheet).to be_invalid
      end

      it 'invalid with one minute overlap' do
        create(:timesheet)
        overlapping_timesheet = build(:timesheet,
          start_time: Time.zone.parse('15:59'),
          end_time: Time.zone.parse('19:00')
        )
        expect(overlapping_timesheet).to be_invalid
      end

      it 'is valid when the times are the same but date is different' do
        create(:timesheet)
        second_timesheet = build(:timesheet, date: mocks[:date] - 1)

        expect(second_timesheet).to be_valid
      end
    end
  end

  describe 'Calculating Amount' do
    let(:monday) { Date.new(2019, 7, 1) }
    let(:tuesday) { Date.new(2019, 7, 2) }
    let(:saturday) { Date.new(2019, 7, 6) }

    describe 'Monday Wednesday Friday' do
      # Rates:
      # 07:00 - 19:00 -> $22 per hour
      # other times   -> $33 per hour
      let(:min_rate) { 22 }
      let(:max_rate) { 33 }

      let(:min_rate_timesheet) do
        create(:timesheet,
          date: monday,
          start_time: Time.zone.parse('7:00'),
          end_time: Time.zone.parse('19:00')
        )
      end

      let(:max_rate_timesheet) do
        create(:timesheet,
          date: monday,
          start_time: Time.zone.parse('1:00'),
          end_time: Time.zone.parse('5:00')
        )
      end

      let(:both_rates_timesheet) do
        create(:timesheet,
          date: monday,
          start_time: Time.zone.parse('1:00'),
          end_time: Time.zone.parse('19:00')
        )
      end

      it 'calculates when only min rate' do
        total_hours = (19 - 7)
        total_expected_amount = total_hours * min_rate
        expect(min_rate_timesheet.amount).to eq(total_expected_amount)
      end

      it 'calculates when only max rate' do
        total_hours = (5 - 1)
        total_expected_amount = total_hours * max_rate
        expect(max_rate_timesheet.amount).to eq(total_expected_amount)
      end

      it 'calculates when both min and max rates' do
        total_min_hours = (19 - 7)
        total_max_hours = (5 - 1)
        total_expected_amount = (total_max_hours * max_rate) + (total_min_hours * min_rate)
        expect(both_rates_timesheet.amount).to eq(total_expected_amount)
      end
    end

    describe 'Tuesday Thursday' do
      it 'calculates when only $25 hourly rate'
      it 'calculates when only $35 hourly rate'
      it 'calculates when both $25 and $35 hourly rate'
    end
  end

  it 'can handle different timezones'
  it 'handles incorrect datatypes correctly'
  it 'date can be string but has to be the right format'
end

# TODO: calculate amount
# TODO: allow user to fix errors and try again (without page refreshing) - take params and render with params
# TODO: display all timesheets as expected
# TODO: display date in readable format
# TODO: display start_time and end_time in readable format

# ! additional optional CRUD:
# TODO: get all timesheets
# TODO: get single timesheet
# TODO: edit timesheet
# TODO: delete timesheet
