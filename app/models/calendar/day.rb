# frozen_string_literal: true

module Calendar
  class Day < ApplicationRecord
    has_many :project_days, dependent: :destroy, foreign_key: 'calendar_day_id'
    has_many :assigned_resources, through: :project_days

    validates :date, uniqueness: true

    def prepare_data(resource)
      return 0 if skip_date?(resource)
      
      project_days.includes(:assigned_resource).where(resource_id: resource.id).sum do |pd|
        pd.assigned_resource&.consumed_per_day || 0
      end
    end

    private

    def skip_date?(resource)
      resource.events.where(type: 'Vacation').any? do |event|
        event.range.include?(date)
      end
    end
  end
end
