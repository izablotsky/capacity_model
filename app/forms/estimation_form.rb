# frozen_string_literal: true

class EstimationForm < BaseForm
  attr_accessor :id, :adjustment_id, :hours, :resource_type_id

  validates :hours, :resource_type_id, :adjustment_id, presence: true

  delegate :project, to: :estimation

  def update
    return false if invalid?

    estimation.update(estimation_params)
  end

  private

  def save!
    estimation = Estimation.new(estimation_params)
    estimation.save!
  end

  def estimation
    @estimation ||= Estimation.find(id)
  end

  def estimation_params
    {
      hours: hours,
      adjustment_id: adjustment_id,
      resource_type_id: resource_type_id
    }
  end
end
