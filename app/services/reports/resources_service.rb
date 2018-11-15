# frozen_string_literal: true

module Reports
  class ResourcesService
    def initialize(_params = {})
      @projects = Project.all
      @days = Calendar::Day.includes(:assigned_resources, :project_days)
      @data = {}
    end

    def call
      @data[:monthes] = []
      @data[:data] = {}
      @days.each do |day|
        day.project_days.each do |project_day|
          next if (assigned_resource = project_day.assigned_resource).blank?

          @data[:data][assigned_resource.resource_type_id] ||= {}
          date = project_day.date.strftime('%B-%y')
          @data[:monthes] << date if @data[:monthes].exclude?(date)
          if @data[:data][assigned_resource.resource_type_id][date]
            @data[:data][assigned_resource.resource_type_id][date] += assigned_resource.consumed_per_day
          else
            @data[:data][assigned_resource.resource_type_id][date] = assigned_resource.consumed_per_day
          end
        end
      end
      Reports::BaseResult.new(data: @data, type: :render, endpoint: 'reports/resources')
    end
  end
end
