class Timesheet < ApplicationRecord
  validates :date, :start_time, :end_time, presence: true
  validate :start_time_cannot_be_after_end_time
  validate :date_cannot_be_in_the_future
  validate :time_sheet_cannot_overlap

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
          if overlaps?(timesheet)
            errors.add(:base, 'Timesheets cannot overlap')
            return self.errors
          end
        end
      end
    end
  end

  def overlaps?(other)
    a_start = start_time.seconds_since_midnight
    a_end = end_time.seconds_since_midnight
    b_start = other.start_time.seconds_since_midnight
    b_end = other.end_time.seconds_since_midnight

    if (a_start...a_end).overlaps?(b_start...b_end)
      return true
    end
  end
end
