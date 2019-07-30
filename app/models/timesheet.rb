class Timesheet < ApplicationRecord
  validates :date, :start_time, :end_time, presence: true
  validate :start_time_cannot_be_after_end_time
  validate :date_cannot_be_in_the_future

  private

  def start_time_cannot_be_after_end_time
    if start_time.present? && end_time.present?
      if start_time >= end_time
        errors.add(:start_time, 'must be before end time')
      end
    end
  end
end
