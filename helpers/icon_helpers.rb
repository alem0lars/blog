module IconHelpers

  def icon(name)
    content_tag(:i, class: "material-icons") { name.to_s }
  end

end
