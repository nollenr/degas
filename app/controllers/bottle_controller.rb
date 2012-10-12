class BottleController < ApplicationController
  helper_method :sort_column, :sort_direction, :show_avail

  def index

    v_find_hash = {}
    v_find_hash[:include] = [:grape, :winery]
    v_find_hash[:order] = sort_column + " " + sort_direction
    if show_avail == 'true'
      v_find_hash[:conditions] = {available: true} 
    end
    @bottles = Bottle.all(v_find_hash)

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

private
  def sort_column
    params[:sort] || "bottle_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def show_avail
    params[:show_avail_next] || false
  end

end
