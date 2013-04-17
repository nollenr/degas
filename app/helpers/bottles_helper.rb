module BottlesHelper

  def is_dashed?(astring)
   logger.debug "********************************** Found a dash #{astring}" if astring =~ /\-/
    astring =~ /\-/ ? true : false
  end

  def parse_text_bottle_ids(astring)
    @bottle_ids = astring.delete(' ').split(/\s*-\s*/)
    logger.debug "********************************** Parsed bottle id #{@bottle_ids}"
    logger.debug "********************************** Count of @bottle_id_text #{@bottle_ids.count}"
    @bottle_ids
  end

  def bottle_id_exists?(p_bottle_id)
    @temp = current_user.bottles.find_by_bottle_id(p_bottle_id)
    @temp ? true : false
  end
end
