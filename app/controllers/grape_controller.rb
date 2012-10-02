class GrapeController < ApplicationController

  def index
    @grapes = Grape.all
  end

end
