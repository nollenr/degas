module ApplicationHelper

  def sortable_button(column, title = nil)
    title ||= column.titleize
    # Add the chevron icon to the title if the column is being sorted.
    title = title + (sort_icon_chevron(column) ? "  " + sort_icon_chevron(column): "")
    # check to see if the column passed in is the current sorted column
    # and if it is currently ascending, then make it descending
    # sort_column and sort_direction are methods in bottles_controller
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title.html_safe, params.merge(sort: column, direction: direction), remote: true, class: "btn btn-primary"
  end

  def sort_icon_chevron (column)
    if column == sort_column
      sort_direction == "asc" ? "<i class=\"icon-chevron-up\"></i> " : "<i class=\"icon-chevron-down\"></i> "
    end
  end


  def full_title(page_title)
    base_title = "Degas"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def consumed_message(consume_date)
    "Consumed " + consume_date.try(:strftime, "%m/%d/%Y %I:%M%P")
  end
end
