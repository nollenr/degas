class BottleController < ApplicationController

  def index
    @bottles = Bottle.find :all, select: "*, case when available then 'Available' else 'Consumed' end as availability"
  end

	def consume
    redirect_to grapes_path
  end

end
