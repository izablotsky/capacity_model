# frozen_string_literal: true

class AssignedResource < ApplicationRecord
  scope :by_type, ->(id) { where(resource_type_id: id) }

  belongs_to :resource
  belongs_to :project
  has_many :project_days, dependent: :destroy
  has_many :calendar_days, through: :project_days, class_name: 'Calendar::Day'

  def _start_date
    (start_date || project.start_date).to_date
  end

  def _end_date
    (end_date || project.end_date).to_date
  end

  def working_days
    _start_date.business_dates_until(_end_date + 1)
  end

  def distribution?
    forecast_type_id.zero?
  end

  def allocation?
    !distribution?
  end

  def resource_type_name
    Settings.resource_types.to_h.key(resource_type_id)
  end

  def allocated_per_day
    work_day_time * (involvement.to_f / 100)
  end

  def work_day_time
    (resource.general_capacity.to_f / 100) * Settings.assumptions.working_hours.to_f
  end

  def consumed_per_day
    if distribution?
      work_day_time.round(1)
    else
      allocated_per_day
    end
  end

  def hours_consumed
    total_estimation = project.estimations.total(resource_type_id).to_f

    return (work_day_time.to_f * working_days.size.to_f).round(1) if distribution?

    assigned_time = allocated_per_day * working_days.size.to_f
    (assigned_time > total_estimation ? total_estimation : assigned_time).round(1)
  end
end
