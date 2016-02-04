import os, sys
sys.path.append(os.curdir)
from pelicanconf import *


# Set the base URL to be used in production.
SITEURL = 'http://alem0lars.anapnea.net'

RELATIVE_URLS = False

# Enable feed generation in production.
FEED_ALL_ATOM = 'feeds/all.atom.xml'
FEED_ALL_RSS = 'feeds/all.rss.xml'
CATEGORY_FEED_ATOM = 'feeds/%s.atom.xml'

DELETE_OUTPUT_DIRECTORY = True

# Following items are often useful when publishing

#DISQUS_SITENAME = ""
#GOOGLE_ANALYTICS = ""
#GOOGLE_ANALYTICS_UNIVERSAL and GOOGLE_ANALYTICS_UNIVERSAL_PROPERTY (Universal tracking code)
