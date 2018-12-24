class EstimationsController < ApplicationController
  def edit
    @estimation_form = EstimationForm.new(estimation.attributes)
    render partial: 'form'
  end

  def update
    @estimation_form = EstimationForm.new(estimation_params)
    if @estimation_form.update
      render partial: 'shared/estimation', locals: { object: estimation, project_id: estimation_params[:project_id] }
    else
      render partial: 'form'
    end
  end

  def destroy
    estimation.destroy
    redirect_to edit_project_path(params[:project_id])
  end

  private

  def estimation
    @estimation ||= Estimation.find(params[:id])
  end

  def estimation_params
    params.require(:estimation_form).permit(:id, :hours, :adjustment_id, :resource_type_id, :project_id)
  end
end
