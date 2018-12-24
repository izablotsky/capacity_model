# frozen_string_literal: true

class ProjectForm < BaseForm
  attr_accessor :id, :uid, :name, :price, :currency, :status, :client_id,
                :start_date, :end_date, :adjustments, :estimations, :assigned_resources

  validates :uid, :name, :price, :currency, :status, :client_id, :start_date, :end_date, presence: true
  # validate :assign_resource_dates

  has_many :assigned_resources, class_name: AssignedResourceForm.to_s
  has_many :estimations, class_name: EstimationForm.to_s

  def initialize(params = {})
    @adjustments = []
    @assigned_resources = []
    @estimations = []
    super
  end

  def build_adjustment
    Adjustment.new
  end

  def build_estimations
    EstimationForm.new
  end

  def build_assigned_resource
    AssignedResourceForm.new
  end

  private

  def save!
    Project.transaction do
      project = Project.new(project_params)
      project.save!

      adjustment = project.adjustments.build(start_date: project_params[:start_date], end_date: project_params[:end_date], default: true)
      adjustment.save!

      assigned_resources.each do |ar|
        ar.adjustment_id = adjustment.id

        raise ActiveRecord::Rollback unless ar.save
      end

      estimations.each do |estimation|
        estimation.adjustment_id = adjustment.id
        raise ActiveRecord::Rollback unless estimation.save
      end
    end

    true
  rescue ActiveRecord::Rollback => e
    errors.add(:base, e.message)

    false
  end

  def update!
    Project.find(id).update(project_params)
  end

  def project_params
    {
      uid: uid,
      name: name,
      price: price,
      currency: currency,
      status: status,
      client_id: client_id,
      start_date: start_date,
      end_date: end_date
    }
  end

  def assign_resource_dates
    assigned_resources.each do |resource|
      if resource.start_date.present? && start_date.present? && resource.start_date.to_date < start_date.to_date
        resource.errors.add(:start_date, 'can not be before start project date')
      end

      if resource.end_date.present? && end_date.present? && resource.end_date.to_date < start_date.to_date
        resource.errors.add(:end_date, 'can not be before start project date')
      end
    end

    errors.add(:base, 'Assigned resources are invalid') if assigned_resources.select { |x| x.errors.any? }.any?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Project')
  end
end
