class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event_form = EventForm.new
  end

  def create
    @event_form = EventForm.new(event_params)
    if @event_form.submit
      Google::Calendar::Events::CreateService.new(current_user, event_params).call
    else
      render 'new'
    end
  end

  private

  def event_params
    params.require(:event_form).permit(:start_date,
                                       :end_date,
                                       :summary,
                                       :creator_name,
                                       :creator_email,
                                       :type,
                                       :resource_id)
  end
end
