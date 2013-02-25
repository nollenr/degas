class BottlesController < ApplicationController
  helper_method :sort_column, :sort_direction, :show_avail

  before_filter :signed_in_user

  def new
    @bottle = Bottle.new
  end

  def create
    @bottle = current_user.bottles.new(params[:bottle])
    if @bottle.save
      flash[:success] = "Bottle created."
      redirect_to :bottles
    else
      render 'new'
    end
  end

  def index
    logger.debug "*****************   Bottle Controller Index: #{params.inspect}"
    @search = current_user.bottles.includes(:bottle_type, :winery, :grape).search(params[:q])
    # This was a huge mistake and a mis-comprehension regarding active record.
    # @bottles = @search.result.order(sort_column + " " + sort_direction).joins(:grape, :winery)
    # To see what the query looks like add the following 2 lines
    # @query =   @search.result.order(sort_column + " " + sort_direction).to_sql
    # logger.debug "************************** Index #{@query}"
    @bottles = @search.result.order(sort_column + " " + sort_direction)
    @bottles = @bottles.where(available: 't') unless params[:q]

    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.erb
      format.csv  { send_data @bottles.to_csv }
    end #end repond_to
  end   #end index method

  def update
    logger.debug "*****************   Controller: #{params.inspect}"
    if params.has_key?(:rating) # Rating Update Begin
      if !params.has_key?(:bottle) 
        flash.now[:error] = "Please choose a rating 0-9."
        @bottle = current_user.bottles.find_by_id(params[:id])
        render 'rate_edit'
      else
        bottle = current_user.bottles.update(params[:id], rating: params[:bottle][:rating])
        if bottle.save
          flash[:success] = "Bottle rating updated."
          redirect_to :bottles
        else
          render 'rate_edit'
        end
      end 
    # Rating Update End
    else #Bottle Update Begin
      @bottle = current_user.bottles.find_by_id(params[:id])
      if @bottle.update_attributes(params[:bottle])
        flash[:success] = "Bottle updated"
        redirect_to :bottles
      else
        flash[:error] = "Update unsuccessful."
        render 'edit'
      end
    end #Bottle Update End
  end

  def consume
    @bottleid = params[:id].to_s
    bottle = current_user.bottles.update(params[:id], available: :false)
    bottle.save
    flash.now[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    respond_to do |format|
      format.html { redirect_to bottle_index_path } #index.html.erb
      format.js   #consume.js.erb
    end #end repond_to
  end

  def copy
    # available default value is "true"
    @source_bottle = current_user.bottles.find_by_id(params[:id])
    @bottle = @source_bottle.dup
    @bottle[:bottle_id] = nil
    @bottle[:available] = :true
    @bottle[:rating] = nil
    render 'new'
  end

  def edit
    @bottle = current_user.bottles.find_by_id(params[:id])
    render 'new'
  end

  def rate_edit
    @bottle = current_user.bottles.find_by_id(params[:id])
  end


private
  def sort_column
    params[:sort] || "bottle_id"
  end

  def sort_direction
    # sanitize the direction... only 2 directions should be allowed
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
