# include 'ApplicationController.helpers.timesheet_helper'
# require 'rails_helper'
require 'pry'

class Timesheet < ApplicationRecord
  validates :date, :start_time, :end_time, presence: true
  validate :start_time_cannot_be_after_end_time
  validate :date_cannot_be_in_the_future
  validate :time_sheet_cannot_overlap

  before_create :calculate_amount

  private

  def start_time_cannot_be_after_end_time
    if start_time.present? && end_time.present?
      errors.add(:start_time, 'must be before end time') if start_time >= end_time
    end
  end

  def date_cannot_be_in_the_future
    if date.present?
      errors.add(:date, 'cannot be in the future') if date > Date.current
    end
  end

  def time_sheet_cannot_overlap
    if start_time.present? && end_time.present?
      Timesheet.all.map do |timesheet|
        unless timesheet.id == id || date != timesheet.date
          errors.add(:base, 'Timesheets cannot overlap') if overlaps?(timesheet)
          # return self.errors
        end
      end
    end
  end

  def overlaps?(other)
    a_start = start_time.seconds_since_midnight
    a_end = end_time.seconds_since_midnight
    b_start = other.start_time.seconds_since_midnight
    b_end = other.end_time.seconds_since_midnight

    (a_start...a_end).overlaps?(b_start...b_end)
  end

  def calculate_amount
    day = ApplicationController.helpers.fetch_day(self)
    if %w[Monday Wednesday Friday].include?(day)
      min_rate = 22.0
      max_rate = 33.0
      min_rate_start = Time.zone.parse('7:00').seconds_since_midnight.to_i
      min_rate_end = Time.zone.parse('19:00').seconds_since_midnight.to_i
      
      # create_min_rate_set
      min_rate_set = Set.new(min_rate_start...min_rate_end)
      
      # create timesheet Set:
      start_time_seconds = start_time.seconds_since_midnight.to_i
      end_time_seconds = end_time.seconds_since_midnight.to_i
      timesheet_set = Set.new(start_time_seconds...end_time_seconds)
      
      total_min_rate_seconds = timesheet_set.intersection(min_rate_set).length
      min_rate_amount = (total_min_rate_seconds * min_rate) / 3600
      # binding.pry
      
      self.amount = min_rate_amount
    end
  end
end


