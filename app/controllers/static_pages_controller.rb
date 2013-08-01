class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @current_cellar_size = current_user.bottles.where(available: true).count
      @current_ratings = current_user.bottles.where("rating is not null").count
    end
  end

  def help
  end

  def about
  end

end
