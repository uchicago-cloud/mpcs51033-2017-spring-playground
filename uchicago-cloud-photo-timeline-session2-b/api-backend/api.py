# api.py

import cgi
import datetime
import urllib
import webapp2
import json
import logging

from google.appengine.api import taskqueue
from google.appengine.api import mail

from default.models import *

class MainPage(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.write('API!')

app = webapp2.WSGIApplication([
    ('/api/', MainPage),
], debug=True)
