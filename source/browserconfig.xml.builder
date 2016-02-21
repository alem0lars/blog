xml.instruct!
xml.browserconfig do
  xml.msapplication do
    xml.tile do
      %w(
        mstile-70x70.png
        mstile-150x150.png
        mstile-310x310.png
        mstile-310x150.png
      ).each do |src|
        unless data.favicons.any? { |favicon_info| favicon_info[:icon] == src }
          fail("Missing favicon declaration for `#{src}`.")
        end
      end
      xml.square70x70logo src:   "/mstile-70x70.png"
      xml.square150x150logo src: "/mstile-150x150.png"
      xml.square310x310logo src: "/mstile-310x310.png"
      xml.wide310x150logo src:   "/mstile-310x150.png"
    end
  end
end
