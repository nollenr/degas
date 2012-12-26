class GrapeController < ApplicationController

  before_filter :signed_in_user

  def index
    @grapes = Grape.all
  end

  def list
    @grapes = Grape.order(:name).where("name ilike ?", "%#{params[:term]}%")
    render json: @grapes.map(&:name)
  end

end
