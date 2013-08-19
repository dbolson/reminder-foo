class EventsController < ApplicationController
  def index
    @events = current_account.events
  end

  def show
    @event = current_account.events.find(params[:id])
  end
end
