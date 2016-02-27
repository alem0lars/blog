module TagHelpers
  TRIGGER_TOOLTIP_CLASS  = "trigger-tooltip"
  TRIGGER_SIDENAV_CLASS  = "trigger-sidenav"
  TRIGGER_DROPDOWN_CLASS = "trigger-dropdown"
  TRIGGER_MODAL_CLASS    = "trigger-modal"

  def link_to_dropdown(name, &blk)
    fail "No content provided" unless block_given?
    content_tag(:a, class: TRIGGER_DROPDOWN_CLASS, "data-activates": name, &blk)
  end

  def link_to_sidenav(name, &blk)
    fail "No content provided" unless block_given?
    content_tag(:a, class: TRIGGER_SIDENAV_CLASS, "data-activates": name, &blk)
  end

  def link_to_modal(target_id, dismissible: true, opacity: 8,
                    in_duration: 300, out_duration: 200, &blk)
    fail "No content provided" unless block_given?
    content_tag(:a,
      class: TRIGGER_SIDENAV_CLASS,
      href: "##{target_id}",
      "data-dismissible": dismissible ? "true" : "false",
      "data-opacity": opacity,
      "data-in-duration": in_duration,
      "data-out-duration": out_duration,
      &blk)
  end

  def tooltipped(tooltip: nil, pos: nil)
    fail("Invalid tooltip") if tooltip.nil? || tooltip.empty?
    fail("Invalid content") if content.nil? || content.empty?

    fragment = Nokogiri::HTML.fragment(yield)

    fragment[:"data-tooltip"]  = tooltip
    fragment[:"data-position"] = pos unless pos.nil? || pos.empty?
    fragment[:class] << " #{TRIGGER_TOOLTIP_CLASS}"

    fragment.inner_html
  end
end