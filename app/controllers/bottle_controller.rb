class BottleController < ApplicationController

  def index

    @before_changes = params[:show_avail_next]
    @params_has_key = params.has_key?(:show_avail_next)
    params[:show_avail_next] = params.has_key?(:show_avail_next) ? params[:show_avail_next] : false
    v_find_hash = {}
    v_find_hash[:joins] = [:grape, :winery]
    v_find_hash[:order] = 'grapes.name'
    if params[:show_avail_next] == 'true'
      v_find_hash[:conditions] = {available: true} 
    end
    @bottles = Bottle.all(v_find_hash)

    @after_changes = params[:show_avail_next]

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

end
