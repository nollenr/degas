class WineriesController < ApplicationController

  def list
    @wineries = Winery.order(:name).where("name like ?", "%#{params[:term]}%")
    render json: @wineries.map(&:name)
  end

end
