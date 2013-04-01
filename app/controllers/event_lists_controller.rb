class EventListsController < ApplicationController
  respond_to :json, :xml

  def index
    @event_lists = EventList.all
    respond_with(@event_lists)
  end

  def show
    @event_list = EventList.find(params[:id])
    respond_with(@event_list)
  end

  def create
    @event_list = EventList.new(params[:event_list])

    if @event_list.save
      render nil
    else
      render nil, status: :bad_request
    end
  end

  def update
    @event_list = EventList.find(params[:id])

    if @event_list.update_attributes(params[:event_list])
      render nil
    else
      render nil, status: :not_modified
    end
  end

  def destroy
    @event_list = EventList.find(params[:id])
    @event_list.destroy
    respond_with(@event_list)
  end
end
