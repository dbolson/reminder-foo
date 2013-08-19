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
    @event_list = current_account.event_lists.build(valid_params)

    if @event_list.save
      flash[:info] = 'Successfully created new list.'
      redirect_to event_lists_path
    else
      render 'new'
    end
  end

  private

  def valid_params
    params.require(:event_list).permit(:name)
  end
end
