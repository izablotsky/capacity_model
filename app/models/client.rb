# == Schema Information
#
# Table name: clients
#
#  id           :bigint(8)        not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  abbreviation :string(255)
#

class Client < ApplicationRecord
  has_many :projects

  def projects_active
    projects.where(status: Project::STATUS[:active])
  end

  def projects_completed
    projects.where(status: Project::STATUS[:completed])
  end

  def projects_in_progress
    projects.where(status: Project::STATUS[:in_progress])
  end
end
