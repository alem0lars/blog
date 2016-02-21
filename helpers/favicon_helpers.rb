# Tags for including favicons.
#
module FaviconHelpers

  # Generate a link tag for all of the favicons tags declared in the
  # `favicons.yml` data file.
  #
  def favicon_tags
    data.favicons.collect do |favicon_info|
      sizes = if favicon_info.key? :size
                "#{favicon_info[:size]}x#{favicon_info[:size]}"
              end
      extname = File.extname(favicon_info[:icon]).gsub(".", "")
      tag(:link,
          rel:   favicon_info[:rel], type: "image/#{extname}",
          sizes: sizes, href: "/#{favicon_info[:icon]}")
    end.join
  end

end
