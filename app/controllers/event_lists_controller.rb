class EventListsController < ApplicationController
  respond_to :json, :xml

  def index
    @event_lists = EventList.all
  end

  def show
    @event_list = EventList.find(params[:id])
  end

  def create
    @event_list = EventList.new(params[:event_list])

    if @event_list.save
      render nil
    else
      render nil, status: :unprocessable_entity
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
  end
end
