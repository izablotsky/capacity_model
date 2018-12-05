module Reports
  class BaseService
    def initialize(params = {})
      @assigned_resources = AssignedResource.includes(:project, resource: [:vacations]).all
      @params = params
    end
  end
end
