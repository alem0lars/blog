################################################################################
# Setup paths                                                                  #
################################################################################

config[:layout]       = "application"
config[:fonts_dir]    = "assets/fonts"
config[:images_dir]   = "assets/images"
config[:js_dir]       = "assets/javascripts"
config[:css_dir]      = "assets/stylesheets"
config[:build_dir]    = "build"
config[:partials_dir] = "" # Empty makes `source` as the starting dir.

################################################################################
# Setup features                                                               #
################################################################################

# Configure HAML.
config[:haml] = {ugly: true, format: :html5}

# Configure Markdown support (using `redcarpet` and enabling its extensions).
config[:markdown_engine] = :redcarpet
config[:markdown] = {
  no_intra_emphasis: true,
  tables: true,
  fenced_code_blocks: true,
  autolink: true,
  strikethrough: true,
  space_after_headers: true,
  superscript: true,
  underline: true,
  highlight: true,
  quote: true,
  footnotes: true
}

# Automatic set image dimensions attributes when using the `image_tag` helper.
activate :automatic_image_sizes

# Provide XML preprocessing support (using `builder`).
require "builder"

# Make favicons (using `middleman-favicon-maker`).
activate :favicon_maker, icons: {
  File.join(config.images_dir, "favicon-base.png") => data.favicons
}

# Enable and configure `middleman-blog`.
config[:blog_prefix] = "blog"
activate :blog do |blog|
  blog.paginate  = true
  blog.summary_separator = /END_OF_SUMMARY/
  blog.layout = config[:blog_prefix]

  blog.prefix    = config[:blog_prefix]
  blog.sources   = "{category}/{year}-{month}-{day}-{title}.html"
  blog.permalink = "{category}/{year}/{month}/{day}/{title}.html"
  blog.taglink   = "tags/{tag}.html"
end

# Enable and configure `middleman-search`.
activate :search do |search|
  search.resources = ["#{config[:blog_prefix]}/", 'index.html']

  search.index_path = "search-index.json"

  search.fields = {
    title:   {boost: 100, store: true, required: true},
    content: {boost: 50},
    url:     {index: false, store: true},
    author:  {boost: 30}
  }

  search.pipeline = {
    tildes: <<-JS
      function(token, tokenIndex, tokens) {
        return token
          .replace('á', 'a')
          .replace('é', 'e')
          .replace('í', 'i')
          .replace('ó', 'o')
          .replace('ú', 'u');
      }
    JS
  }
end

# Enable and configure `middleman-livereload`.
configure :development do
  activate :livereload,
    # Reload Javascript/CSS with complete reload of the page (not in-place).
    apply_js_live: false, apply_css_live: false
end

# Minify stuff for production.
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
end

# Compress stuff for production.
configure :build do
  activate :gzip
end

# Enable directory indexes, i.e. create a folder for each `.html` file and
# place the built template file as the index of that folder.
# Notes: the directory indexes are available only in a `middleman build`,
# but not using the development webserver (i.e. using `middleman server`).
activate :directory_indexes
config[:trailing_slash] = true

# Caching configuration.
configure :build do
  # Improve caching using uniquely-named assets for preventing users from using
  # outdated cached files.
  activate :asset_hash do
    asset_hash.exts << '.json' # JSON files are not considered by default.
  end
end

activate :external_pipeline,
  name: :webpack,
  command: build? ? "./node_modules/webpack/bin/webpack.js --bail" :
                    "./node_modules/webpack/bin/webpack.js --watch -d",
  source: ".tmp/dist",
  latency: 1

################################################################################
# Setup pages                                                                  #
################################################################################

# With no layout.
page "/*.xml",  layout: false
page "/*.json", layout: false
page "/*.txt",  layout: false
