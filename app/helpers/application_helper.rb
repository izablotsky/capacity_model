module ApplicationHelper
  def dashboard_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options = options, name if block_given?
    url = url_for(options)
    html_options ||= { class: '' }
    html_options[:class] += ' active'  if url.include?(controller_name)

    block_given? ? link_to(options, html_options) { yield } : link_to(name, options, html_options)
  end

  def status_class(project)
    Settings.project.classes.to_h[project.status_name]
  end

  def resource_type_name(id)
    Settings.resource_types.to_h.key(id)
  end

  def currency_name(currency)
    Settings.currencies.to_h.key(currency)
  end

  def distribution?(assigned_resource)
    assigned_resource.forecast_type_id.zero?
  end

  def forecast_type(id)
    Settings.assigned_resource.forecast.types.to_h.key(id)
  end
end
