# frozen_string_literal: true

class AssignedResourceForm < BaseForm
  attr_accessor :id, :resource_id, :project_id, :resource_type_id, :start_date, :end_date, :involvement, :_destroy,
                :forecast_type_id

  validates :resource_id, :resource_type_id, presence: true, numericality: { only_integer: true }

  private

  def save!
    resource = AssignedResource.new(assigned_resource_params)
    resource.save!
  end

  def assigned_resource_params
    {
      resource_id: resource_id,
      project_id: project_id,
      resource_type_id: resource_type_id,
      start_date: start_date,
      end_date: end_date,
      involvement: involvement,
      forecast_type_id: forecast_type_id
    }
  end
end
