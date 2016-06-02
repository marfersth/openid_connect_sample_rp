OpenIDConnect.logger = WebFinger.logger = SWD.logger = Rack::OAuth2.logger = Rails.logger
OpenIDConnect.debug!

# this should be set for all environments, otherwise discover request (GET .well-known/:id) is
# not being executed in production for example
SWD.url_builder = WebFinger.url_builder = URI::HTTP