class ReportsController < ApplicationController
  def index
    with_service_handling do
      @result = report_for(params[:type], params)
    end
  end
end
