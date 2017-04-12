"""A simple application that demonstrates sharding counters.

Counters can be sharded to achieve higher throughput.

Demonstrates:
   * Sharding - Sharding a counter into N random pieces.
   * Memcache - Using memcache to cache the total counter value in
                general_counter.
"""


import webapp2
from webapp2_extras import jinja2

import general_counter
import simple_counter


DEFAULT_COUNTER_NAME = 'TOUCHES'


class CounterHandler(webapp2.RequestHandler):
    """Handles displaying counter values and requests to increment a counter.

    Uses a simple and general counter and allows either to be updated.
    """
    
    @webapp2.cached_property
    def jinja2(self):
        return jinja2.get_jinja2(app=self.app)

    def render_response(self, template, **context):
        rendered_value = self.jinja2.render_template(template, **context)
        self.response.write(rendered_value)

    def get(self):
        """GET handler for displaying counter values."""
        simple_total = simple_counter.get_count()
        general_total = general_counter.get_count(DEFAULT_COUNTER_NAME)
        self.render_response('counter.html', simple_total=simple_total,
                             general_total=general_total)

    def post(self):
        """POST handler for updating a counter which is specified in payload."""
        counter = self.request.get('counter')
        if counter == 'simple':
            simple_counter.increment()
        else:
            general_counter.increment(DEFAULT_COUNTER_NAME)
        self.redirect('/')


APPLICATION = webapp2.WSGIApplication([('/', CounterHandler)],
                                      debug=True)
