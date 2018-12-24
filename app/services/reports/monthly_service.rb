# frozen_string_literal: true

module Reports
  class MonthlyService < BaseService
    def call
      report = @adjustments.each_with_object({}) do |adjustment, memo|
        adjustment.assigned_resources.each do |assigned_resource|
          memo[assigned_resource.name] ||= {}
          assigned_resource.working_days.each do |date|
            next if date.year.to_s != @params[:year]
            if memo[assigned_resource.name][date.strftime('%B')].present?
              memo[assigned_resource.name][date.strftime('%B')] += assigned_resource.consumed_per_day
            else
              memo[assigned_resource.name][date.strftime('%B')] = assigned_resource.consumed_per_day
            end
          end
        end
      end
      MonthlyResult.new(report: report, type: :render, endpoint: 'reports/monthly')
    end
  end
end
