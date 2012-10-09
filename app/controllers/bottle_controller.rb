class BottleController < ApplicationController

  def index
    # removed and replaced with the after_find in the model
    # @bottles = Bottle.find :all, 
    # select: "*, case when available then 'Available' else 'Consumed' end as availability", order: "bottle_id"

    @before_changes = params[:show_avail_next]
    @params_has_key = params.has_key?(:show_avail_next)
    params[:show_avail_next] = params.has_key?(:show_avail_next) ? params[:show_avail_next] : false
    # @bottles = params[:show_avail_next] == 'true' ? Bottle.where(available: true).order(params[:sort]) : Bottle.order(params[:sort]).all
    # @bottles = Bottle.find(:all, conditions: "bottle_id = 322", include: :grape, order: 'grapes.name')
      order_by = 'grapes.name'
      @bottles = Bottle.find(:all, include: [:grape], order: order_by)
    # @bottles = Bottle.joins(:grape).where(available: true).order('grapes.name')

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
