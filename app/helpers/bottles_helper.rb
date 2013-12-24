module BottlesHelper

  def is_dashed?(astring)
   # logger.debug "********************************** Found a dash #{astring}" if astring =~ /\-/
    astring =~ /\-/ ? true : false
  end

  def parse_text_bottle_ids(astring)
    @bottle_ids = astring.delete(' ').split(/\s*-\s*/)
    # logger.debug "********************************** Parsed bottle id #{@bottle_ids}"
    # logger.debug "********************************** Count of @bottle_id_text #{@bottle_ids.count}"
    @bottle_ids
  end

  def bottle_id_exists?(p_bottle_id)
    @temp = current_user.bottles.find_by_bottle_id(p_bottle_id)
    @temp ? true : false
  end
  
  def class_config_offsets(p_level)
    # v_class = "col-xs-" + (7-p_level).to_s
    v_class = "col-xs-1"
    if p_level != 0
      v_class += " col-xs-offset-" + p_level.to_s
    end
    # v_class += " col-md-" + (11-p_level).to_s
    v_class += " col-md-1"
    if p_level != 0
      v_class += " col-md-offset-" + p_level.to_s
    end
    return v_class.html_safe
  end
  
  def get_class_definitions(p_level, p_md_total_length, p_md_button_length, p_md_value_length, p_xs_total_length, p_xs_button_length, p_xs_value_length)
    v_class_definitions = Hash.new
    v_class_definitions["col-md-button"] = "col-md-" + p_md_button_length.to_s
    v_class_definitions["col-xs-button"] = "col-xs-" + p_xs_button_length.to_s
    v_class_definitions["col-md-value"] = "col-md-" + p_md_value_length.to_s
    v_class_definitions["col-xs-value"] = "col-xs-" + p_xs_value_length.to_s
    v_class_definitions["col-md-offset-display"] = "col-md-offset-" + p_level.to_s
    v_class_definitions["col-xs-offset-display"] = "col-xs-offset-" + p_level.to_s
    v_class_definitions["col-md-display"] = "col-md-" + (p_md_total_length-(p_level + p_md_button_length + p_md_value_length)).to_s
    v_class_definitions["col-xs-display"] = "col-xs-" + (p_xs_total_length-(p_level + p_xs_button_length + p_md_value_length)).to_s
    return v_class_definitions
  end
  
  def generate_wrapped_html(p_hash)
    md_total_length  = 8
    md_button_length = 1
    md_value_length  = 1
    xs_total_length  = 10
    xs_button_length = 1
    xs_value_length  = 1

    v_class_definitions = get_class_definitions(p_hash["level"], md_total_length, md_button_length, md_value_length, xs_total_length, xs_button_length, xs_value_length)
    # logger.debug("#{v_class_definitions.inspect}")
    
    # standlone html code for the topmost items of the expanding list
    html1 = "".html_safe


    ################################################################################################
    # Button:                                                                                      #
    # First item on the line is the button (to expand or reduce the list).  Create the button,     #
    # and wrap it in the column html which has the column length plus the offset.                  #
    ################################################################################################
    if p_hash["number_of_children"] != 0
      html1 = content_tag(:button, content_tag(:span, "", class: "glyphicon glyphicon-chevron-down"), class: "btn btn-default btn-xs collapse-btn", type: "button", data: {toggle: "collapse", target: p_hash["data_target"]})
    end
    # wrap html1 (the button sibling) in a column wrapper
    html1 = content_tag(:div, html1, class: v_class_definitions["col-xs-button"]+" " +v_class_definitions["col-xs-offset-display"]+" "+v_class_definitions["col-md-button"]+" "+v_class_definitions["col-md-offset-display"])

    ################################################################################################
    # Display Text                                                                                 #
    # The second item is the display text which may be a link.  Create the display text or link    #
    # and wrap it in the column html.                                                              #
    ################################################################################################
    if p_hash["create_link"]
      html2 = link_to p_hash["display_value"], bottles_path("q"=>{p_hash["search_param"]=>p_hash["display_value"], "available_true"=>"1"})
    else
      html2 = p_hash["display_value"].html_safe
    end
    # wrap html2 (the display name sibling) in a column wrapper
    html2 = content_tag(:div, html2, class: v_class_definitions["col-xs-display"]+" "+v_class_definitions["col-md-display"])

    ################################################################################################
    # Value                                                                                        #
    # The third item is the value.  Wrap the value in html, then wrap that in the column html.     #
    ################################################################################################
    # wrap html3 (the value) in a column wrapper
    html3 = content_tag(:div, p_hash["sum_or_avg_of_children"], class: v_class_definitions["col-xs-value"]+" "+v_class_definitions["col-md-value"])
    
    v_class="row dataline" #row is for bootstrap
    if p_hash["number_of_children"] != 0
      v_class += " collapse-space"
    end

    ################################################################################################    
    # this is the outter most wrapper for an item.  It wraps columns above in a row wrapper.       #  
    # if this row has children, make it collapsable by adding the "collapse-space class(above)"    #
    ################################################################################################
    concat content_tag(:div, html1 + html2 + html3, class: v_class)
    concat "\n".html_safe
  end
  
  def create_recursive_html(p_hash, p_level = 0)
    p_hash.each {|key, value|
      # data_target is the id to look for when collapsing a div.  to make a unique value, i took the rowID (value[3]) + "level" + the level numerical value
      generate_wrapped_html({"display_value"=>value[4]["formatted_key"], "data_target"=>"#" + value[3].to_s + "level" + p_level.to_s, "sum_or_avg_of_children"=>value[4]["row_value"], "level"=> p_level, "number_of_children"=>value[2], "create_link"=>value[4]["create_link"], "search_param"=>value[4]["search_param"]  })
      #wrap all children in an enclosing div
      if !value[0].empty?
        # this id (in the div) must be the same as the data-target above.
        concat "<div id='#{value[3].to_s + "level" + p_level.to_s}' class='collapse'>\n".html_safe
          create_recursive_html(value[0], p_level + 1)
        concat "</div>\n".html_safe
      end
    } #end of the p_hash.each loop
  end
  
  def all_params_empty?(param_hash)
    #preserve the original hash
    temp_hash = param_hash.clone
    temp_hash.delete("available_true")
    temp_hash.delete("available_false")
    temp_hash.delete_if{ |key, value| value.empty? }
    #logger.debug("*****************   checking if all params are empty: #{temp_hash.inspect} length: #{temp_hash.length}")
    return temp_hash.empty? ? true : false
  end
  
  def search_box_helper(search_params)
    # Here's something to remember.  When pagination is used (i.e. the user hits a "page number button"), 
    # 
    #if search_params is nil, then set it to the empty hash
    #logger.debug "*****************   Starting helper"    
    #logger.debug "*****************   search_params initialization (Before): #{search_params.inspect}"
    search_params ||= {}
    #logger.debug "*****************   search_params initialization (After): #{search_params.inspect}"
    search_box_hash = Hash.new
    #logger.debug "*****************   search_params full params (Before): #{params.inspect}"
    case
    when search_params.empty?
      # params[:q] is empty (showing all bottles)
      # this is the easiest case... it means I'm showing all bottles, and the search list needs to be expanded
      #logger.debug "*****************   search_params - case is Showing all bottles"
      search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-up"
      search_box_hash[:collapseClass] = "collapse in"
      search_box_hash[:available_radio] = "all"
    when search_params.has_key?("available_false")
      # another easy case... it means I'm showing only consumed bottles, and the search list needs to be expanded
      # showing only consumed bottles
      #logger.debug "*****************   search_params - case is Showing only consumed bottles"
      search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-up"
      search_box_hash[:collapseClass] = "collapse in"
      search_box_hash[:available_radio] = "consumed"
    when search_params.has_key?("available_true")
      # I have to check all other search options to be sure they're empty
      # showing only available bottles (default behavior)
      if all_params_empty?(search_params)
        #logger.debug "*****************   search_params - case is Showing only available bottles -- default behavior -- no need to show search panel"
        search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-down"
        search_box_hash[:collapseClass] = "collapse"
        search_box_hash[:available_radio] = "available"
      else
        #logger.debug "*****************   search_params - case is Showing only available bottles but other params are non-empty"
        search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-up"
        search_box_hash[:collapseClass] = "collapse in"
        search_box_hash[:available_radio] = "available"
      end
    when search_params.has_key?("is_for_rating_only_true")
      #logger.debug "*****************   search_params - case is Showing rating only bottles."
      search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-up"
      search_box_hash[:collapseClass] = "collapse in"
      search_box_hash[:available_radio] = "ratingOnly"
    else
      #logger.debug "*****************   search_params - case is All search params are empty -- I must be showing all bottles -- same as first case"
      search_box_hash[:buttonClass] = "glyphicon glyphicon-chevron-up"
      search_box_hash[:collapseClass] = "collapse in"
      search_box_hash[:available_radio] = "all"
    end
    #logger.debug "*****************   search_params full params  (After): #{params.inspect} and search_box_hash #{search_box_hash.inspect}"
    return search_box_hash
  end

  def get_AvailabilityChangeReason_collection
    @availability_change_reasons = AvailabilityChangeReasonLookup.select("id, reason").order("display_order")
    return @availability_change_reasons
  end

end
