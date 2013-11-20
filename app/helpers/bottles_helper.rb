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
  
  def class_config(p_level)
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
  
  def generate_wrapped_html(p_hash)
    # standlone html code for the topmost items of the expanding list
    html1 = "".html_safe
    
    # there are 3 inner html siblings html1:button, html2:display name, html3:value

    # inner most html sibling 1: The button.  The button will be abesent if it has no children. Always offset for indentation.
    if p_hash["number_of_children"] != 0
      html1 = content_tag(:button, content_tag(:span, "", class: "glyphicon glyphicon-chevron-down"), class: "btn btn-default btn-xs collapse-btn", type: "button", data: {toggle: "collapse", target: p_hash["data_target"]})
    end
    # wrap the the inner most html sibling in a column wrapper
    html1 = content_tag(:div, html1, class: class_config(p_hash["level"]))
    
    #create html2
    if p_hash["create_link"]
      html2 = link_to p_hash["display_value"], bottles_path("q"=>{p_hash["search_param"]=>p_hash["display_value"], "available_true"=>"1"})
    else
      html2 = p_hash["display_value"].html_safe
    end
    # wrap html2 in a column wrapper
    html2 = content_tag(:div, html2, class: "col-xs-3 col-md-5")
    
    # wrap the innner most html sibling #3 in a column wrapper 
    html3 = content_tag(:div, p_hash["sum_or_avg_of_children"], class: "col-xs-1 col-md-1")
    
    v_class="row dataline"
    if p_hash["number_of_children"] != 0
      v_class += " collapse-space"
    end
    
    # this is the outter most wrapper for an item.  It wraps the two columns above in a row wrapper.  
    # if this row has children, make it collapsable by adding the "collapse-space class(above)"   
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

end
