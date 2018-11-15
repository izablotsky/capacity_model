class EventForm
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :html_link, :status, :summary,
                :creator_name, :creator_email, :type, :resource_id

  validates_presence_of :start_date, :end_date, :creator_email, :summary, :resource
  validates :start_date, numericality: { less_than: :end_date }

  def initialize(params = {})
    @resource_id   = params[:resource_id]
    @start_date    = params[:start_date]
    @end_date      = params[:end_date]
    @html_link     = params[:html_link]
    @status        = params[:status]
    @summary       = params[:summary]
    @creator_name  = params[:creator_name]
    @creator_email = params[:creator_email]
    @type          = params[:type]
  end

  def submit
    return false if invalid?

    resource.events.create do |event|
      event.start_date    = @start_date
      event.end_date      = @end_date
      event.html_link     = @html_link
      event.status        = @status
      event.summary       = @summary
      event.creator_name  = @creator_name
      event.creator_email = @creator_email
      event.type          = @type.humanize
    end
  end

  private

  def resource
    @resource ||= Resource.find(resource_id)
  end

  # def start_date_cannot_be_greater_than_end_date
  #   return if start_date < end_date
  #   errors.add(:start_date, 'Start Date should be')
  # end
end
