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
    v_class = "col-md-" + (11-p_level).to_s
    if p_level != 0
      v_class += " col-md-offset-" + p_level.to_s
    end
    return v_class
  end
  
  def level_0(p_hash)
    # standlone html code for the topmost items of the expanding list
    html1 = ""
    if p_hash["number_of_children"] != 0
      html1 = content_tag(:button, content_tag(:span, "", class: "glyphicon glyphicon-plus"), class: "btn", type: "button", data: {toggle: "collapse", target: p_hash["data_target"]})
    end
    html1 += p_hash["display_value"].html_safe
    html1 = content_tag(:div, html1, class: class_config(p_hash["level"]))
    html2 = content_tag(:div, p_hash["sum_or_avg_of_children"], class: "col-md-1")
    concat content_tag(:div, html1 + html2, class: "row")
    concat "\n".html_safe
  end
  
  def create_recursive_html(p_hash, p_level = 0, p_collapseID = nil)
    p_hash.each {|key, value|
      level_0({"display_value"=>key, "data_target"=>"#" + key, "sum_or_avg_of_children"=>value[1], "level"=> p_level, "number_of_children"=>value[2]})
      #wrap all children in an enclosing div
      if !value[0].empty?
        concat "<div id='#{key}' class='collapse'>\n".html_safe
          create_recursive_html(value[0], p_level + 1, key)
        concat "</div>\n".html_safe
      end
    } #end of the p_hash.each loop
  end

end
