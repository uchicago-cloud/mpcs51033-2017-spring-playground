import cgi
import datetime
import urllib
import webapp2
import json
import logging

from google.appengine.api import taskqueue
from google.appengine.api import mail

from default.models import *

class EmailTaskHandler(webapp2.RequestHandler):
    """Handler for task queue emails"""

    def get(self):
        message = self.request.get('message', default_value='default')
        logging.info('This is an info message')
        mail.send_mail(sender="me@uchicago-mobi-photo-timeline.appspotmail.com",
        to="abinkowski@uchicago.edu",
        subject="New Photo!",
        body="A new photo has been uploaded to your account.")

################################################################################
#
################################################################################
app = webapp2.WSGIApplication([
    ('/tasks/summary_email/', EmailTaskHandler)
    ],
    debug=True)
