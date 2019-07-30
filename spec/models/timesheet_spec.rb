require 'rails_helper'
require 'date'
# FactoryBot.find_definitions

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

    it 'is not valid when date is in the future'
    it 'is not valid when times overlap'
  end
end
