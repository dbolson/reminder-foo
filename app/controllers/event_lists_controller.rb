class EventListsController < ApplicationController
  respond_to :json, :xml

  def index
    @event_lists = EventList.all
  end

  def show
    @event_list = EventList.find(params[:id])
  end

  def edit
    @event_list = EventList.find(params[:id])
  end

  def update
    @event_list = EventList.find(params[:id])

    if @event_list.update_attributes(params[:event_list])
      render json: @event_list
    else
      render json: @event_list, status: :unprocessable_entity
    end
  end
end
