module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {sort: column, direction: direction}
  end

  def sort_icon (column)
    if column == sort_column
      css_icon = sort_direction == "asc" ? "<i class=\"icon-hand-up\"></i> ".html_safe : "<i class=\"icon-hand-down\"></i> ".html_safe
    end
  end
end
