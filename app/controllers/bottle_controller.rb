class BottleController < ApplicationController

  def index
    # @bottles = Bottle.find :all, select: "*, case when available then 'Available' else 'Consumed' end as availability", order: "bottle_id"
    @bottles = Bottle.order("bottle_id").all
  end

	def consume
    bottle = Bottle.update(params[:id], available: :false)
    bottle.save
    flash[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    redirect_to bottle_index_path
  end

end
