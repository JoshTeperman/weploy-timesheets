require 'rails_helper'
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
    end

    it 'can handle different timezones'
    it 'handles incorrect datatypes correctly'
    it 'date can be string but has to be the right format'

    # TODO: calculate amount
    # TODO: get all timesheets
    # TODO: display timesheet information correctly
  end
end
