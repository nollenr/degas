class BottleController < ApplicationController

  def index
    # removed and replaced with the after_find in the model
    # @bottles = Bottle.find :all, 
    # select: "*, case when available then 'Available' else 'Consumed' end as availability", order: "bottle_id"

    params[:only_available] = params.has_key?(:only_available) ? params[:only_available] : false
    @bottles = params[:only_available] ? Bottle.where(available: true) : Bottle.order("bottle_id").all

    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.erb
    end #end repond_to
  end   #end index method

  def consume
    bottle = Bottle.update(params[:id], available: :false)
    bottle.save
    flash[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    redirect_to bottle_index_path
  end

end
