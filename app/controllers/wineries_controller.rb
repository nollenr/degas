class WineriesController < ApplicationController

  def list
    @wineries = Winery.order(:name).where("name ilike ?", "%#{params[:term]}%")
    render json: @wineries.map(&:name)
  end

end
