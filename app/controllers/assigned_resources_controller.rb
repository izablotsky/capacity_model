class AssignedResourcesController < ApplicationController
  def edit
    @assigned_resource_form = AssignedResourceForm.new(assigned_resource.attributes)
    respond_to do |format|
      format.js { render partial: 'form' }
    end
  end

  def update
    @assigned_resource_form = AssignedResourceForm.new(assigned_resource_params)
    if @assigned_resource_form.update
      render partial: 'shared/assigned_resource', locals: { object: assigned_resource,
                                                            project_id: assigned_resource_params[:project_id] }
    else
      render partial: 'form'
    end
  end

  def destroy
    assigned_resource.destroy
    flash[:success] = 'Assigned resource was successfully destroyed'
    redirect_to edit_project_path(params[:project_id])
  end

  private

  def assigned_resource
    @assigned_resource ||= AssignedResource.find(params[:id])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def assigned_resource_params
    params.require(:assigned_resource_form).permit(:id,
                                                   :project_id,
                                                   :adjustment_id,
                                                   :resource_id,
                                                   :resource_type_id,
                                                   :distribution_involvement,
                                                   :allocation_involvement,
                                                   :forecast_type_id,
                                                   :start_date,
                                                   :end_date)
  end
end
