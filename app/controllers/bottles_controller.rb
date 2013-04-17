class BottlesController < ApplicationController
  helper_method :sort_column, :sort_direction, :show_avail

  before_filter :signed_in_user

  def new
    @bottle = Bottle.new
  end

  def create
    @bottle = current_user.bottles.new(params[:bottle])
    # Test to see if there is a dash in the bottle_id_text, which means we want a range of bottle id's created.
    if is_dashed?(params[:bottle][:bottle_id_text])
      @bottle_id_text = parse_text_bottle_ids(params[:bottle][:bottle_id_text])
      # If there was a dash AND it is confirmed, then I should try and commit it.
      if (params[:bottle][:confirmed])
        for x in @bottle_id_text[0]..@bottle_id_text[1] do
          @new_bottle = current_user.bottles.new(params[:bottle])
          @new_bottle[:bottle_id] = x
          @new_bottle.save
        end
        flash[:success] = "Bottles created."
        redirect_to :bottles and return
      end
      # If there was a dash, then do 1 get 2 "pieces", a "from" and a "to" range?
      if @bottle_id_text.count != 2
        flash[:error] = "'Bottle Identifier' is not correct.  " +
          "Either supply a single integer or a range separated by a '-'.  Ex: 1124 or 1124-1128"
        render 'new' and return
      else #okay, I got a "from" and a "to" range
        # Are the "from" and "to" numbers integers?
        if (Integer(@bottle_id_text[0]) rescue false) and (Integer(@bottle_id_text[1]) rescue false)
          @bottle_id_text[0] = Integer(@bottle_id_text[0])
          @bottle_id_text[1] = Integer(@bottle_id_text[1])
          logger.debug "********************************** Got two good numbers"
          # Do the two integers make sense (i.e. is one less than the other)
          if (Integer(@bottle_id_text[0])) <= (Integer(@bottle_id_text[1]))
          # Is the range of numbers unique (i.e. do any of them already exist in the database?
          for x in @bottle_id_text[0]..@bottle_id_text[1] do
            if (bottle_id_exists?(x))
              flash[:error] = "Invalid bottle identifier. " +
               "ID #{x} already exists in your cellar.  Enter a new bottle id."
              render 'new' and return
            end
          end
            render action: 'confirm'
          else
            flash[:error] = "'Bottle Identifier' is not correct.  " +
              "Either supply a single integer or a range separated by a '-'.  Ex: 1124 or 1124-1128"
            render 'new' and return
          end
        else #Did not get two good numbers
          logger.debug "********************************** Did not get two good numbers"
          flash[:error] = "'Bottle Identifier' is not correct.  " +
            "Either supply a single integer or a range (no alpha or special characters) " +
            "separated by a '-'.  Ex: 1124 or 1124-1128"
          render 'new' and return
        end
      end
    else #No dash in the bottle_id_text so try to save it and move on.
      @bottle[:bottle_id] = params[:bottle][:bottle_id_text].delete(' ')
      unless (Integer(@bottle[:bottle_id]) rescue false)
        flash[:error] = "Invalid bottle identifier. " +
          "Either supply a single integer or a range separated by a '-'.  Ex: 1124 or 1124-1128"
        render 'new' and return
      end
      if (bottle_id_exists?(@bottle[:bottle_id]))
        flash[:error] = "Invalid bottle identifier. " +
          "That ID already exists in your cellar.  Enter a new bottle id."
        render 'new' and return
      end
      if @bottle.save
        flash[:success] = "Bottle created."
        redirect_to :bottles
      else
        render 'new'
      end      
    end
  end

  def index
    # logger.debug "*****************   Bottle Controller Index: #{params.inspect}"
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
