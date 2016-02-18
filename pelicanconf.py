import os, glob


# Base URL of your website. Not defined by default, so it is best to specify
# your SITEURL; if you do not, feeds will not be generated with properly-formed
# URLs.
# In development this should be empty.
SITEURL = ''

# Path to content directory to be processed by Pelican.
# Defaults to the current working directory.
PATH = 'content'

# The timezone used in the date information, to generate Atom and RSS feeds.
TIMEZONE = 'UTC'

# The default language to use.
DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing.
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Use document-relative URLs when developing.
RELATIVE_URLS = True

# Enable the `materialize` theme.
THEME = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'theme')
from functools import partial
JINJA_FILTERS = {
    'sort_by_article_count': partial(
        sorted, key=lambda tags: len(tags[1]), reverse=True)
    } # Reversed for descending order.

# Enable plugins.
PLUGIN_PATHS = ['plugins']
PLUGINS = ['materialbox', 'plantuml', 'assets']

# PlantUML plugin configuration.
PLANTUML_PREAMBLE = '''
skinparam backgroundcolor transparent
'''

# Static files.
STATIC_PATHS = []
for reldir in ['data', 'src']:
    STATIC_PATHS += list(map(lambda x: os.path.relpath(x, 'content'),
                         glob.glob('content/ctfs/*/*/{}'.format(reldir))))

# The maximum number of articles to include on a page, not including orphans.
# False to disable pagination.
DEFAULT_PAGINATION = 16

# The default author.
AUTHOR = 'alem0lars'
# The site name.
SITENAME = AUTHOR

# Whether to display pages on the menu of the template.
DISPLAY_PAGES_ON_MENU = True
# Whether to display categories on the menu of the template.
DISPLAY_CATEGORIES_ON_MENU = True
# A list of tuples (Title, URL) for additional menu items to appear at the
# beginning of the main menu.
MENUITEMS = ()

# A list of tuples (Title, URL) to appear in the "social" section.
SOCIAL = (('Twitter', 'https://twitter.com/alem0lars'),
          ('LinkedIN', 'https://www.linkedin.com/in/molarialessandro'),
          ('Github', 'https://github.com/alem0lars'),)
# A list of tuples (Title, URL) for links to appear on the header.
LINKS = (('CeSeNA Security', 'https://cesena.ing2.unibo.it/'),)
