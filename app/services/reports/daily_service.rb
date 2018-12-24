module Reports
  class DailyService < BaseService
    def call
      report = @adjustments.each_with_object({}) do |adjustment, memo|
        adjustment.assigned_resources.each do |assigned_resource|
          memo[assigned_resource.name] ||= {}
          assigned_resource.working_days.each do |date|
            if memo[assigned_resource.name][date].present?
              memo[assigned_resource.name][date] += assigned_resource.consumed_per_day
            else
              memo[assigned_resource.name][date] = assigned_resource.consumed_per_day
            end
          end
        end
      end
      BaseResult.new(report: report, type: :render, endpoint: 'reports/daily')
    end
  end
end
