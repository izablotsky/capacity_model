# frozen_string_literal: true

class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: %i[edit update destroy]

  def new
    @adjustment = AdjustmentForm.new
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end

  def create
    @adjustment = AdjustmentForm.new(adjustment_params)
    @project = Project.find(params[:project_id])
    if @adjustment.save
      redirect_to projects_path, notice: 'Adjustment was successfully created.'
    else
      render :new
    end
  end

  def edit
    @adjustment = AdjustmentForm.new
  end

  def update
    @adjustment = AdjustmentForm.new
  end

  def destroy
    @adjustment.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Adjustment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_adjustment
    @adjustment = Adjustment.find(params[:id])
  end

  def adjustment_params
    params.fetch(:adjustment_form, {})
  end
end
