# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  email            :string(255)
#  resource_type_id :integer
#  general_capacity :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


class Resource < ApplicationRecord
  has_many :assigned_resources
  has_many :adjustments, through: :assigned_resources
  has_many :projects, through: :adjustments
  has_many :events
  has_many :vacations

  alias assigned_projects assigned_resources

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def daily_capacity
    8.0 * general_capacity / 100
  end
end
