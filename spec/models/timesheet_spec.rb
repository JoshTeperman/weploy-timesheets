require 'rails_helper'
require 'date'
# FactoryBot.find_definitions

RSpec.describe Timesheet, type: :model do
  describe 'Model validations' do
    before do
      Timesheet.destroy_all
    end
    # let(:factory_timesheet) { create(:timesheet) }

    # let(:factory_timesheet) { FactoryBot.create(:timesheet) }
    let(:valid_timesheet) do
      date = Date.new
      start_time = Time.parse('9:00')
      end_time = Time.parse('18:00')
      Timesheet.new(date: date, start_time: start_time, end_time: end_time)
    end

    let(:invalid_timesheet) do
      start_time = Time.parse('9:00')
      end_time = Time.parse('18:00')
      Timesheet.create(start_time: start_time, end_time: end_time)
    end

    it 'is invalid when intialized without attributes' do
      expect(Timesheet.new).to be_invalid
    end

    it 'FactoryBot Timesheet is valid' do
      test_timesheet = build(:timesheet)
      p test_timesheet
      p test_timesheet.date
      p test_timesheet.start_time
      p test_timesheet.end_time
      expect(test_timesheet).to be_valid
    end

    it 'is valid with valid attributes' do
      expect(valid_timesheet).to be_valid
    end

    it 'is not valid without a date' do
      expect(invalid_timesheet).to be_invalid
    end
    
    it 'is not valid without a start_time'
    it 'is not valid without a end_time'
    it 'is not valid when date is in the future'
    it 'is not valid when times overlap'
    it 'is not valid when end_time is before start_time'
  end


    # test_timesheet = Timesheet.create(Date.new)
    # expect(test_timesheet).to
end
