require 'rails_helper'
require_relative '../../app/helpers/timesheets_helper'
require 'date'

RSpec.describe Timesheet, type: :model do
  describe 'Model validations' do    
    before do
      Timesheet.destroy_all
    end

    let(:valid_timesheet) do
      build(:timesheet)
    end

    let(:mocks) do
      attributes_for(:timesheet)
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

      describe 'Calculating Amount' do
        describe 'method: calculate_amount' do
          it 'calculates Monday Wednesday Friday for one hourly rate'
          it 'calculates Monday Wednesday Friday for two hourly rates'
          it 'calculates Tuesday Thursday for one hourly rate'
          it 'calculates Tuesday Thursday for two hourly rates'
        end
      end
    end

    
    it 'can handle different timezones'
    it 'handles incorrect datatypes correctly'
    it 'date can be string but has to be the right format'

  end
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
