class EventListsController < ApplicationController
  respond_to :json, :xml

  def index
    @event_lists = EventList.all
  end

  def show
    @event_list = EventList.find(params[:id])
  end
end
