class BottleController < ApplicationController
  helper_method :sort_column, :sort_direction, :show_avail

  before_filter :signed_in_user

  def new
    @bottle = Bottle.new
  end

  def create
    @bottle = Bottle.new(params[:bottle])
    if @bottle.save
      redirect_to :bottle_index
    else
      render 'new'
    end
  end

  def index
    @param_string = params.to_s
    @search = Bottle.search(params[:q])
    @search_result = @search.result.to_sql
      @bottles = @search.result.order(sort_column + " " + sort_direction).joins(:grape, :winery)
      @query =   @search.result.order(sort_column + " " + sort_direction).joins(:grape, :winery).to_sql

    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.erb
    end #end repond_to
  end   #end index method

  def consume
    @bottleid = params[:id].to_s
    bottle = Bottle.update(params[:id], available: :false)
    bottle.save
    flash[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    # redirect_to bottle_index_path
    respond_to do |format|
      format.html { redirect_to bottle_index_path } #index.html.erb
      format.js   #consume.js.erb
    end #end repond_to
  end

  def copy
    # available default value is "true"
    @source_bottle = Bottle.find_by_id(params[:id])
    @bottle = @source_bottle.dup
    @bottle[:bottle_id] = nil
    @bottle[:available] = :true
    render 'new'
  end

private
  def sort_column
    params[:sort] || "bottle_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
