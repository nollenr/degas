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
  
  def level_0(p_hash)
    html1 = content_tag(:button, content_tag(:span, "", class: "glyphicon glyphicon-plus"), class: "btn", type: "button", data: {toggle: "collapse", target: p_hash["data_target"]}) + p_hash["display_value"]
    html1 = content_tag(:div, html1, class:"col-md-11")
    html2 = content_tag(:div, p_hash["sum_or_avg_of_children"], class: "col-md-1")
    concat content_tag(:div, html1 + html2, class: "row")
  end
  
  def level_1(p_hash)
    html1 = content_tag(:div, p_hash["display_value"], class: "col-md-10 col-md-offset-1")
    html2 = content_tag(:div, p_hash["sum_or_avg_of_children"], class: "col-md-1")
    content_tag(:div, html1 + html2, class: "row")
  end
  
  def create_recursive_html(p_hash, p_level = 0, p_collapseID = nil)
    p_hash.each {|key, value|
      # outter most (top) level
      if p_level == 0
        level_0({"display_value"=>key, "data_target"=>"#"+key, "sum_or_avg_of_children"=>value[1]})
      end
    }

  end

end
