# frozen_string_literal: true

class AssignedResourceForm < BaseForm
  attr_accessor :id, :resource_id, :adjustment_id, :resource_type_id, :start_date,
                :end_date, :distribution_involvement, :allocation_involvement,
                :forecast_type_id

  validates :resource_id, :resource_type_id, :adjustment_id, presence: true, numericality: { only_integer: true }
  validates :start_date, :end_date, date: true

  delegate :project, to: :assigned_resource

  def update
    return false if invalid?

    assigned_resource.update(assigned_resource_params)
  end

  def start_date=(value)
    @start_date ||= value.try(:to_date)
  end

  def end_date=(value)
    @end_date ||= value.try(:to_date)
  end

  private

  def save!
    AssignedResource.create!(assigned_resource_params)
  end

  def assigned_resource_params
    {
      resource_id: resource_id,
      adjustment_id: adjustment_id,
      resource_type_id: resource_type_id,
      start_date: start_date,
      end_date: end_date,
      distribution_involvement: distribution_involvement,
      allocation_involvement: allocation_involvement,
      forecast_type_id: forecast_type_id
    }
  end

  def assigned_resource
    @assigned_resource ||= AssignedResource.find(id)
  end
end
