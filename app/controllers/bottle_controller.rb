class BottleController < ApplicationController

  def index
    # removed and replaced with the after_find in the model
    # @bottles = Bottle.find :all, 
    # select: "*, case when available then 'Available' else 'Consumed' end as availability", order: "bottle_id"

    @before_changes = params[:show_avail_next]
    @params_has_key = params.has_key?(:show_avail_next)
    params[:show_avail_next] = params.has_key?(:show_avail_next) ? params[:show_avail_next] : false
    @bottles = params[:show_avail_next] ? Bottle.where(available: true) : Bottle.order("bottle_id").all
    @after_changes = params[:show_avail_next]

    respond_to do |format|
      format.html #index.html.erb
      # format.js   #index.js.erb
    end #end repond_to
  end   #end index method

  def consume
    bottle = Bottle.update(params[:id], available: :false)
    bottle.save
    flash[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    redirect_to bottle_index_path
  end

end
