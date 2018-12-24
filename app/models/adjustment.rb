# frozen_string_literal: true

# == Schema Information
#
# Table name: adjustments
#
#  id         :bigint(8)        not null, primary key
#  date       :datetime
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Adjustment < ApplicationRecord
  belongs_to :project
  has_many :estimations, dependent: :destroy
  has_many :assigned_resources, dependent: :destroy
  has_many :resources, through: :assigned_resources

  accepts_nested_attributes_for :assigned_resources, :estimations, allow_destroy: true

  def date_pretty
    date&.strftime(Settings.date_format.first)
  end
end
