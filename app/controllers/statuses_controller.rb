class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @statuses = Status.order('created_at desc')
    respond_with(@statuses)
  end

  def show
    respond_with(@status)
  end

  def new
    @status = current_user.statuses.new
    respond_with(@status)
  end

  def edit
  end

  def create
    @status = current_user.statuses.new(status_params)
    if @status.save
      redirect_to statuses_path, success: 'Status was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @status.update(status_params)
      redirect_to statuses_path, success: 'Status was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    if @status.destroy
      redirect_to statuses_path, success: 'Status was successfully deleted.'
    else
      redirect_to statuses_path, error: 'Status could not be deleted.'
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:content)
  end
end
