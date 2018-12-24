# frozen_string_literal: true

# == Schema Information
#
# Table name: estimations
#
#  id               :bigint(8)        not null, primary key
#  project_id       :bigint(8)
#  resource_type_id :integer
#  hours            :integer
#


class Estimation < ApplicationRecord
  scope :by_type, ->(type) { where(resource_type_id: type) }
  scope :total,   ->(type) { by_type(type).sum(:hours) }

  belongs_to :adjustment, optional: true
  delegate :project, to: :adjustment, allow_nil: true

  def resource_type_name
    Settings.resource_types.to_h.key(resource_type_id)
  end
end
