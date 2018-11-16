# frozen_string_literal: true

class Reports::MonthlyService < BaseService
  def initialize(params = {})
    @year = params[:year]
    @days = Calendar::Day.includes(:assigned_resources, :project_days).where(date: (Date.new(@year.to_i, 1, 1)..Date.new(@year.to_i, 12, 31)))
    @resources = Resource.includes(:assigned_resources, :projects)
    @data = {}
  end

  def call
    @data[:resources] = @resources
    @data[:monthes] = {}
    Date::MONTHNAMES.compact.each do |month|
      @data[:monthes][month] = Calendar::Month.new(@days, month, @year)
    end
    Reports::MonthlyResult.new(data: @data, type: :render, endpoint: 'reports/monthly')
  end
end
