class StaticPagesController < ApplicationController

  def home
    @current_cellar_size = current_user.bottles.where(available: true).count
  end

  def help
  end

  def about
  end

end
