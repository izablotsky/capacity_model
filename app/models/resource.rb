# frozen_string_literal: true

class Resource < ApplicationRecord
  has_many :assigned_resources
  has_many :projects, through: :assigned_resources
  has_many :events

  alias assigned_projects assigned_resources

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def daily_capacity
    8.0 * general_capacity / 100
  end
end
