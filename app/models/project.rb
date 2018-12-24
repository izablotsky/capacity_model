# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  uid        :string(5)
#  name       :string(255)
#  price      :integer
#  currency   :integer
#  status     :string(255)
#  start_date :datetime
#  end_date   :datetime
#  client_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Project < ApplicationRecord

  belongs_to :client
  has_many :adjustments, dependent: :destroy
  has_many :assigned_resources, through: :adjustments
  has_many :resources, through: :assigned_resources
  has_many :estimations, through: :adjustments

  accepts_nested_attributes_for :assigned_resources, :estimations, allow_destroy: true

  STATUS = {
    active: [0, 1, 2, 4],
    in_progress: 1,
    not_started: 0,
    pending: 2,
    on_hold: 4,
    completed: 3
  }.freeze

  def self.min_date
    Project.minimum(:start_date)
  end

  def self.max_date
    Adjustment.maximum(:end_date) || Project.maximum(:end_date)
  end

  def status_name
    Settings.project.status.to_h.key(status.to_i)
  end

  def finish_date
    (adjustments.last&.end_date || end_date)
  end

  def code_complete_date
    Settings.assumptions.code_complete_prior.business_days.before(finish_date)
  end

  def resource_types
    from_estimations = estimations.pluck(:resource_type_id)
    from_resources = assigned_resources.pluck(:resource_type_id)
    @resource_types ||= (from_estimations | from_resources).sort
  end

  def estimated_hours_for(id)
    estimations.by_type(id).sum(&:hours)
  end

  def assigned_hours_for(id)
    assigned_resources.by_type(id).sum(&:hours_consumed).round(1)
  end

  def unallocated_hours_for(id)
    hours = estimated_hours_for(id).to_f - assigned_hours_for(id).to_f
    hours >= 0 ? hours : 0
  end

  def estimated_hours(resource_type)
    estimations.group_by(:resou)
  end
end
