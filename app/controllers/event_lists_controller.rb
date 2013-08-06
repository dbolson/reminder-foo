class EventListsController < ApplicationController
  def index
    @event_lists = current_account.event_lists
  end

  def show
    @event_list = current_account.event_lists.find(params[:id])
  end

  def new
    @event_list = current_account.event_lists.new
  end

  def create
    flash[:info] = 'Successfully created new list.'
    redirect_to new_event_list_path
  end

  private

  def current_account
    Account.first
  end
end
