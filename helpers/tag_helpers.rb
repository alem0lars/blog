module TagHelpers
  TRIGGER_TOOLTIP_CLASS  = "trigger-tooltip"
  TRIGGER_SIDENAV_CLASS  = "trigger-sidenav"
  TRIGGER_DROPDOWN_CLASS = "trigger-dropdown"
  TRIGGER_MODAL_CLASS    = "trigger-modal"

  def link_to_dropdown(name, content: nil)
    content_tag(:a,
                content,
                class: TRIGGER_DROPDOWN_CLASS,
                data: {activates: "dropdown-#{name}"})
  end

  def link_to_sidenav(name, content: nil)
    content_tag(:a,
                content,
                class: TRIGGER_SIDENAV_CLASS,
                data: {activates: "sidenav-#{name}"})
  end

  def link_to_modal(name, content: nil, dismissible: true, opacity: 8,
                    in_duration: 300, out_duration: 200)
    content_tag(:a,
                content,
                class: TRIGGER_SIDENAV_CLASS,
                href: "#modal-#{name}",
                data: {dismissible: dismissible, opacity: opacity,
                       in: in_duration, out: out_duration})
  end

  def tooltipped(content: nil, tooltip: nil, pos: nil, &blk)
    fail "Invalid tooltip" unless tooltip

    fragment = Nokogiri::HTML.fragment(content)

    fragment[:"data-tooltip"]  = tooltip
    fragment[:"data-position"] = pos unless pos.nil? || pos.empty?
    fragment[:class] << " #{TRIGGER_TOOLTIP_CLASS}"

    fragment.inner_html
  end
end
