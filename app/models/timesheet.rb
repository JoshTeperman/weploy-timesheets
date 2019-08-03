# require 'rails_helper'
require 'pry'
require_relative '../../lib/rate_schema'
require_relative '../../lib/constants'

class Timesheet < ApplicationRecord
  validates :date, :start_time, :end_time, presence: true
  validate :start_time_cannot_be_after_end_time
  validate :date_cannot_be_in_the_future
  validate :time_sheet_cannot_overlap

  before_create :calculate_timesheet_amount

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

  def calculate_timesheet_amount
    rate_schema = select_rate_schema_for_timesheet
    
    base_rate_range = create_set_from_time_range(
      rate_schema.start_time,
      rate_schema.end_time
    )
    timesheet_range = create_set_from_time_range(
      start_time,
      end_time
    )
    self.amount = total_amount_calculator(
      base_rate_range,
      timesheet_range,
      rate_schema
    )
  end

  def select_rate_schema_for_timesheet
    day = ApplicationController.helpers.fetch_day(self)
    case day
    when 'Monday' || 'Wednesday' || 'Friday'
      MON_WED_FRI_SCHEMA
    when 'Tuesday' || 'Thursday'
      TUES_THURS_SCHEMA
    when 'SAT' || 'SUN'
      WEEKEND_SCHEMA
    end
  end

  def create_set_from_time_range(start_time, end_time)
    start_time_in_seconds = start_time.seconds_since_midnight.to_i
    end_time_seconds = end_time.seconds_since_midnight.to_i
    Set.new(start_time_in_seconds...end_time_seconds)
  end

  def calculate_base_salary(base_rate_range, timesheet_range, base_rate)
    total_seconds = timesheet_range.intersection(base_rate_range).length
    (total_seconds * base_rate) / SECONDS_IN_AN_HOUR
  end

  def calculate_overtime_salary(base_rate_range, timesheet_range, overtime_rate)
    total_seconds = timesheet_range.difference(base_rate_range).length
    (total_seconds * overtime_rate) / SECONDS_IN_AN_HOUR
  end

  def total_amount_calculator(base_rate_range, timesheet_range, rate_schema)
    base_salary = calculate_base_salary(
      base_rate_range,
      timesheet_range,
      rate_schema.base_rate
    )
    overtime_salary = calculate_overtime_salary(
      base_rate_range,
      timesheet_range,
      rate_schema.overtime_rate
    )
    base_salary + overtime_salary
  end
end
