class ClimbsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @climb= current_user.climbs.build(climb_params)
    if @climb.save
      flash[:success] = "Climb created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @climb.destroy
    redirect_to root_url
  end


  private

    def climb_params
      params.require(:climb).permit(:content, :grade)
    end

    def correct_user
      @climb = current_user.climbs.find_by(id: params[:id])
      redirect_to root_url if @climb.nil?
    end
end