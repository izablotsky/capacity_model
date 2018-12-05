module Reports
  class DailyService < BaseService
    def call
      report = @assigned_resources.each_with_object({}) do |assigned_resource, memo|
        memo[assigned_resource.name] ||= {}
        assigned_resource.working_days.each do |date|
          if memo[assigned_resource.name][date].present?
            memo[assigned_resource.name][date] += assigned_resource.consumed_per_day
          else
            memo[assigned_resource.name][date] = assigned_resource.consumed_per_day
          end
        end
      end
      BaseResult.new(report: report, type: :render, endpoint: 'reports/daily')
    end
  end
end
