module Reports
  class ProjectService
    def initialize(params = {})
      @project = Project.find(params[:project_id])
      @assigned_resources = @project.assigned_resources
      @params = params
    end

    def call
      report = @assigned_resources.each_with_object({}) do |assigned_resource, memo|
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
      BaseResult.new(report: report, type: :render, endpoint: 'reports/project')
    end
  end
end
