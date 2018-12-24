module Reports
  class BaseService
    def initialize(params = {})
      # @assigned_resources = AssignedResource.includes(adjustment: [:project], resource: [:vacations]).all
      # @projects = Project.includes(adjustments: [:estimations, :assigned_resources], resources: [:vacations]).to_a
      @adjustments = Adjustment.includes(:project, :estimations, :assigned_resources, resources: [:vacations]).to_a
      @params = params
    end
  end
end
