# frozen_string_literal: true

module Reports
  class ResourcesService < BaseService
    def call
      report = @assigned_resources.group_by(&:resource_type_id).each_with_object({}) do |(type, assigned_resources), memo|
        memo[type] ||= {}
        assigned_resources.each do |assigned_resource|
          assigned_resource.working_days.each do |date|
            next if date.year.to_s != @params[:year]
            memo[type] ||= {}
            if memo[type][date.strftime('%B')].present?
              memo[type][date.strftime('%B')]+= assigned_resource.consumed_per_day
            else
              memo[type][date.strftime('%B')] = assigned_resource.consumed_per_day
            end
          end
        end
      end
      BaseResult.new(report: report, type: :render, endpoint: 'reports/resources')
    end
  end
end
