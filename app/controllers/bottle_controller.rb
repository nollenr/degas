class BottleController < ApplicationController

  def index
    @bottles = Bottle.all
  end

end
