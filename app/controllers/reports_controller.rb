class ReportsController < ApplicationController
  def index
    with_service_handling do
      @result = report_for(params[:type], params)
      @report = @result.report
    end
  end
end
