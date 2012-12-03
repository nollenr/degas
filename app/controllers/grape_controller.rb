class GrapeController < ApplicationController

  before_filter :signed_in_user

  def index
    @grapes = Grape.all
  end

end
