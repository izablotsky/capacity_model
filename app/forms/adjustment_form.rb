# frozen_string_literal: true

class AdjustmentForm < BaseForm
  attr_accessor :id, :start_date, :end_date, :project_id, :assigned_resources, :estimations

  has_many :assigned_resources, class_name: AssignedResourceForm.to_s
  has_many :estimations, class_name: EstimationForm.to_s

  validates :start_date, :end_date, presence: true

  def initialize(params = {})
    @assigned_resources = []
    @estimations = []
    super
  end

  def build_assigned_resources
    AssignedResourceForm.new
  end

  def build_estimation
    EstimationForm.new
  end
  private

  def save!
    Adjustment.transaction do
      Project.find(project_id).adjustments.create! do |adjustment|
        adjustment.start_date = start_date
        adjustment.end_date = end_date
        assigned_resources.each do |assigned_resource|
          adjustment.assigned_resources.build(assigned_resource.params)
        end

        estimations.each do |estimation|
          adjustment.estimations.build(estimation.params)
        end
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)

    false
  end

  def update!; end
end
