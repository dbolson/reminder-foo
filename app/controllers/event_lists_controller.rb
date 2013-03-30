class EventListsController < ApplicationController
  respond_to :json, :xml

  def index
    @event_lists = EventList.all
  end

  def show
    @event_list = EventList.find(params[:id])
  end

  def new
    @event_list = EventList.new
  end

  def create
    @event_list = EventList.new(params[:event_list])

    if @event_list.save
      render json: @event_list, status: :created
    else
      render json: @event_list, status: :bad_request
    end
  end

  def edit
    @event_list = EventList.find(params[:id])
  end

  def update
    @event_list = EventList.find(params[:id])

    if @event_list.update_attributes(params[:event_list])
      render json: @event_list
    else
      render json: @event_list, status: :not_modified
    end
  end
end
