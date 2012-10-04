class BottleController < ApplicationController

  def index
    @bottles = Bottle.find :all, select: "*, case when available then 'Available' else 'Consumed' end as availability", order: "bottle_id"
  end

	def consume
    bottle = Bottle.update(params[:id], available: :false)
    bottle.save
    redirect_to bottle_index_path
  end

end
