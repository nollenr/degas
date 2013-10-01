class BottlesController < ApplicationController
  helper_method :sort_column, :sort_direction, :show_avail, :format_collapsable_list

  before_filter :signed_in_user

  def new
    @bottle = Bottle.new
  end

  def create
    @bottle = current_user.bottles.new(params[:bottle])
    logger.debug(".........................................#{@bottle.inspect}")
    #---------------------------------------------------------------------#
    #                                                                     #
    #  Is this a rating only bottle?                                      #
    #                                                                     #
    #---------------------------------------------------------------------#
    if @bottle.is_for_rating_only
      @nextid = ActiveRecord::Base.connection.execute("SELECT nextval('bottles_id_seq')")
      @bottle.bottle_id = Integer(@nextid[0]["nextval"]) * (-1)
      @bottle.available = false
      if @bottle.save
        flash[:success] = "Rating created."
        redirect_to :bottles
      else
        render 'new'
      end      
    #---------------------------------------------------------------------#
    #                                                                     #
    #  Does the bottle id contain a "-"?                                  #
    #                                                                     #
    #---------------------------------------------------------------------#
    # Test to see if there is a dash in the bottle_id_text, which means we want a range of bottle id's created.
    elsif is_dashed?(params[:bottle][:bottle_id_text])
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
          # logger.debug "********************************** Got two good numbers"
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
          # logger.debug "********************************** Did not get two good numbers"
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
    logger.debug "*****************   Bottle Controller Index: #{params.inspect}"
    @search = current_user.bottles.includes(:bottle_type, :winery, :grape).search(params[:q])
    # This was a huge mistake and a mis-comprehension regarding active record.
    # @bottles = @search.result.order(sort_column + " " + sort_direction).joins(:grape, :winery)
    # To see what the query looks like add the following 2 lines
    # @query =   @search.result.order(sort_column + " " + sort_direction).to_sql
    # logger.debug "************************** Index #{@query}"
    @bottles = @search.result.order(sort_column + " " + sort_direction)
    @bottles = @bottles.where(is_for_rating_only: false) unless params[:q] && params[:q][:is_for_rating_only_true]
    # Checking if the hash key exists, not the value
    @bottles = @bottles.where(available: true) unless params[:q] && params[:q][:available_true]
    # logger.debug("********************** #{@bottles.inspect}")

    respond_to do |format|
      format.html #index.html.erb
      format.js   #index.js.erb
      format.csv  { send_data @bottles.to_csv }
    end #end repond_to
  end   #end index method

  def update
    @bottle = current_user.bottles.find_by_id(params[:id])
    if @bottle.update_attributes(params[:bottle])
      flash[:success] = "Bottle updated"
      redirect_to :bottles
    else
      flash[:error] = "Update unsuccessful."
      render 'new'
    end
  end

  def consume
    # @bottleid = params[:id].to_s
    bottle = current_user.bottles.update(params[:id], available: :false)
    bottle.save
    @bottle = current_user.bottles.find_by_id(params[:id])
    flash.now[:success] = "You have successfully consumed bottle " + bottle.bottle_id.to_s + "!"
    respond_to do |format|
      format.html { redirect_to bottle_index_path } #index.html.erb
      format.js   #consume.js.erb
    end #end repond_to
  end

  def copy
    @source_bottle = current_user.bottles.find_by_id(params[:id])
    @bottle = @source_bottle.dup
    logger.debug "**************************** during copy before setting nil #{@bottle.inspect}"
    @bottle[:bottle_id] = nil
    @bottle[:bottle_id_text] = nil
    @bottle[:available] = true
    @bottle[:availability_change_date] = nil
    @bottle[:rating] = nil
    #logger.debug "**************************** during copy after setting nil #{@bottle.inspect}"    
    render 'new'
  end

  def edit
    @bottle = current_user.bottles.find_by_id(params[:id])
    render 'new'
  end

  def rate
    #logger.debug "rate edit: ********************* #{params.inspect}"
    bottle = current_user.bottles.update(params[:id], rating: params[:rating])
    bottle.save
    @bottle = current_user.bottles.find_by_id(params[:id])
    respond_to do |format|
      format.html #rate.html.erb
      format.js   #rate.js.erb
    end #end repond_to
  end
  
  def toc
    #@bottles=Bottle.where(available: :true).count('*', group: :grape_id)
    @toc_by_grapes_group_by = ['grapes.color', 'grapes.name'] 
    @toc_grape_search_data_key = ['grape_color_eq', 'grape_name_cont']
    @toc_by_grapes = current_user.bottles.where(available: :TRUE).joins(:grape).order('grapes.color, grapes.name').count(:all, group: @toc_by_grapes_group_by).to_a
    @toc_by_wineries = current_user.bottles.where(available: :TRUE).joins(:winery).order('wineries.name').count('*', group: 'wineries.name').to_a
    @toc_by_locations_group_by = ['wineries.country', 'wineries.location1', 'wineries.location2', 'wineries.location3', 'wineries.name']
    @toc_location_search_data_key = [nil, nil, nil, nil, 'winery_name_cont']
    @toc_by_locations = current_user.bottles.where(available: :TRUE).joins(:winery).order('wineries.country, wineries.location1, wineries.location2, wineries.location3, wineries.name').count(:all, group: @toc_by_locations_group_by).to_a
    @toc_by_bottle_types_group_by = ['bottle_types.name']
    @toc_bottle_type_search_data_key = ['bottle_type_name_in']
    @toc_by_bottle_types = current_user.bottles.where(available: :TRUE).joins(:bottle_type).order('bottle_types.name').count(:all, group: @toc_by_bottle_types_group_by).to_a 
    #logger.debug("location array ******************************************** #{@toc_by_locations.inspect}")
  end
  
  def toc_by_grape
    @toc_by_grapes_group_by = ['grapes.color', 'grapes.name'] 
    @toc_grape_search_data_key = ['grape_color_eq', 'grape_name_cont']
    @toc_by_grapes = current_user.bottles.where(available: :TRUE).joins(:grape).order('grapes.color, grapes.name').count(:all, group: @toc_by_grapes_group_by).to_a
    @toc_by_grapes_collapsable_list = format_collapsable_list(@toc_by_grapes, true, @toc_grape_search_data_key)
  end
  
  def toc_by_winery
    @toc_by_wineries_group_by = ['wineries.name', 'grapes.name']
    @toc_winery_search_data_key = ['winery_name_cont', 'grape_name_cont']
    @toc_by_wineries = current_user.bottles.where(available: :TRUE).joins(:winery, :grape).order('wineries.name, grapes.name').count('*', group: @toc_by_wineries_group_by).to_a
    @toc_by_wineries_collapsable_list = format_collapsable_list(@toc_by_wineries, true, @toc_winery_search_data_key)
  end
  
  def toc_by_location
    @toc_by_locations_group_by = ['wineries.country', 'wineries.location1', 'wineries.location2', 'wineries.location3', 'wineries.name']
    @toc_location_search_data_key = [nil, nil, nil, nil, 'winery_name_cont']
    @toc_by_locations = current_user.bottles.where(available: :TRUE).joins(:winery).order('wineries.country, wineries.location1, wineries.location2, wineries.location3, wineries.name').count(:all, group: @toc_by_locations_group_by).to_a    
    @toc_by_locations_collapsable_list = format_collapsable_list(@toc_by_locations, true, @toc_location_search_data_key)
  end
  
  def toc_by_bottle_type
    @toc_by_bottle_types_group_by = ['bottle_types.name']
    @toc_bottle_type_search_data_key = ['bottle_type_name_in']
    @toc_by_bottle_types = current_user.bottles.where(available: :TRUE).joins(:bottle_type).order('bottle_types.name').count(:all, group: @toc_by_bottle_types_group_by).to_a 
  end
  
  def ratings
    @rating_list_group_by = ['wineries.name', 'grapes.name', 'vintage', 'vineyard', 'bottles.name']
    @rating_by_bottle_unformatted = current_user.bottles.where("rating is not null").joins(:grape, :winery).order("average_rating desc").average("rating", group: @rating_list_group_by).to_a
    # Make a hash out of the array returned from ActiveRecord.  This will make the code for the view, much clearer.
    @rating_by_bottle = @rating_by_bottle_unformatted.map{|x| {:winery=>x[0][0], :grape=>x[0][1], :vintage=>x[0][2], :vineyard=>x[0][3], :name=>x[0][4], :avg_rating=>x[1]}}
    # Add two additional keys to the @rating_by_bottle hash
    @rating_by_bottle.map! {|x|
      x[:num_ratings] = current_user.bottles.where('rating is not null and wineries.name = ? and grapes.name = ? and vintage = ? and vineyard = ? and bottles.name = ?', x[:winery], x[:grape], x[:vintage], x[:vineyard], x[:name]).joins(:grape, :winery).count(:all)
      x[:avail_bottles] = current_user.bottles.where('available = ? and wineries.name = ? and grapes.name = ? and vintage = ? and vineyard = ? and bottles.name = ?', true, x[:winery], x[:grape], x[:vintage], x[:vineyard], x[:name]).joins(:grape, :winery).count(:all)
      x # Return the new hash back to the array of hashes, replacing the old hash with the new hash
      }
  end
  
  def winery_ratings
    @rating_list_group_by = ['wineries.name', 'grapes.name', 'vintage', 'vineyard', 'bottles.name']
    @rating_by_winery_unformatted = current_user.bottles.where("rating is not null").joins(:grape, :winery).order("average_rating desc").average("rating", group: @rating_list_group_by).to_a
    # logger.debug("unformatted winery ratings.................................. #{@rating_by_winery_unformatted.inspect}")
    @rating_by_winery = @rating_by_winery_unformatted.map{|x| [[x[0][0], x[0][1] + " " + x[0][3] + " " + x[0][4], x[0][2]], x[1]]}
    # logger.debug("formatted winery ratings .................................... #{@rating_by_winery.inspect}")
    @rating_collapsable_list = format_collapsable_list(@rating_by_winery, true, ["winery_name_cont",nil,nil], true)
  end

  def bottle_for_rating_only
    @bottle = Bottle.new
    @bottle[:is_for_rating_only] = true
    render 'new'
  end
  
  def buy_again   
    logger.debug "buy_again edit: **************************** #{params.inspect}"
    bottle = current_user.bottles.update(params[:id], buy_at_this_price: params[:buy_at_this_price])
    bottle.save
    @bottle = current_user.bottles.find_by_id(params[:id])
    respond_to do |format|
      format.html #buy_again.html.erb
      format.js   #buy_again.js.erb 
    end
  end

private
  def sort_column
    params[:sort] || "bottle_id"
  end

  def sort_direction
    # sanitize the direction... only 2 directions should be allowed
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def create_list_html(p_hash, p_html, p_create_link, p_data_key, p_level, p_average)
    v_data_key = p_data_key[p_level]
    p_html = p_html + '<div class="row-fluid">'
    p_html = p_html + '<ul>'
    p_hash.each{|key, value|
      p_html = p_html + '<li class = "collapse-li">'
      if (p_create_link && !key.nil? && !v_data_key.nil?)
        v_key = view_context.link_to key, bottles_path("q"=>{v_data_key=> key,"available_true"=>"1"})
      else
        v_key = key.nil? ? "Not Listed" : key
      end
      # If the data value is supposed to be an average, then do a divide
      if (p_average)
        v_value = (value[1]/value[2]).round(1)
      else
        v_value = value[1]
      end
      # logger.debug("for v_key #{v_key} p_data_key[#{p_level.inspect}]= #{v_data_key.inspect}")
      p_html = p_html + '<div class="span6 dataval">' + v_key + '</div> <div class="span5 text-right dataval">' + v_value.to_s + '</div>'
      if !value[0].empty?
        p_level = p_level + 1
        p_html = create_list_html(value[0], p_html, p_create_link, p_data_key, p_level, p_average)
        p_level = p_level -1
      end
      p_html = p_html + '</li>'
    }
    p_html = p_html + '</ul>'
    p_html = p_html + '</div>'
    return p_html
  end
  
  def process_array(p_array, p_hash, p_count, p_accum)
    # Build a nested list structure
    # pass in:
    #  1.  An array with 3 elements (usually created from the database)
    #      The first element of the array is an array with any number of elements
    #      The second element of the array is a computation from the database(count, average, etc.)
    #      Example:
    #      [[a, b, c, d, e], 12]
    #      [[a, b, x, y, z], 10]
    #      [[m, n, o, p, q], 15]
    #      [[m, s, t, u, v], 18]
    #      [[m, s, t, u, w], 20]
    #  2.  A hash (the first iteration, this will be an empty hash)
    #  3-4.  A couple of accumulators for summing and averaging.  The first sums the
    #        database computation, the second keep track of the number of records
    # The function will process through the array checking to see if the hash contains
    # the key.  If not it creates it and recursively calls this function to continue processing.
    # each hash key points to an array with two elements.  The first element is a hash, the 
    # second element has the accumulator value.  
    #
    # What you get back is a hash where each element points to an array.  The first element of the 
    # array is a hash, the second element is the accumulated value (the sum of its children) and the 
    # third which is a count of the records in it's tree.  It's a recursive data
    # structure.  The first element of the array (the hash) is either an empty hash (meaning) that 
    # you've arrived at the bottom of the structure, or it has keys that point to arrays with 
    # 2 elements.
    # Example (building)
    # {"a"=>[{"b"=>[{"c"=>[{"d"=>[{"e"=>[{}, 12, 1]}, 12, 1]}, 12, 1]}, 12, 1]}, 12, 1]}
    # {"a"=>[{"b"=>[{"c"=>[{"d"=>[{"e"=>[{}, 12, 1]}, 12, 1]}, 12, 1], "x"=>[{"y"=>[{"z"=>[{}, 10, 1]}, 10, 1]}, 10, 1]}, 22, 2]}, 22, 2]}
    # The "topmost" hash would have 2 elements
    # {a=>[], m=>[]}  Each of those arrays would have 2 elements... a hash and an accumulator
    # b=>[] Which would have 2 elements... a hash and an accumulator
    # {c=>[], x=>[]}
    if (p_array.length == 0)
      return {}
    else
      v_key = p_array.shift
      v_key = v_key == "" ? nil : v_key
      if p_hash.has_key?(v_key)
        p_hash[v_key] = [process_array(p_array, p_hash[v_key][0], p_count, p_accum), p_hash[v_key][1] + p_count, p_hash[v_key][2] + 1]
        return p_hash
      else
        # New hash (key doesn't exist)
        p_hash[v_key] = [process_array(p_array, {}, p_count, 0), p_count, 1] 
        return p_hash         
      end
    end
  end
  
  def format_collapsable_list(p_list, p_create_link, p_data_key, p_average=false)
    a_hash = {}
    p_list.each do |v_row|
      a_hash = process_array(v_row[0], a_hash, v_row[1], 0)
    end
    logger.debug("Hash after completion: #{a_hash}")
    if (p_average)
      a_hash = a_hash.sort_by{|k,v| (v[1]/v[2])}.reverse
    end
    logger.debug("Hash after sorting: #{a_hash}")
    a_html = create_list_html(a_hash, "", p_create_link, p_data_key, 0, p_average)
    # logger.debug("HTML after completion #{a_html}")
    return a_html
  end

end
