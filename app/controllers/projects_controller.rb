# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    projects = Project.includes(:client, :adjustments, :estimations, resources: [:vacations])
    projects = params[:client_id].present? ? projects.where(client_id: params[:client_id]) : projects
    @projects = params[:status].present? ? projects.where(status: Project::STATUS[params[:status].to_sym]) : projects
  end

  def show
    @result = report_for(:project, params)
  end

  def new
    @project = ProjectForm.new
  end

  def edit
    @assigned_resources = @project.assigned_resources
    @estimations = @project.estimations
    @project = ProjectForm.new(@project.attributes)
  end

  def create
    @project = ProjectForm.new(new_project_form_params)

    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    @project = ProjectForm.new(edit_project_form_params)

    if @project.update
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def new_project_form_params
    params.fetch(:project, {})
  end

  def edit_project_form_params
    new_project_form_params.merge(id: params[:id])
  end
end
