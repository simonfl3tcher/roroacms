require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/keys'
require 'action_view/helpers/asset_url_helper'
require 'action_view/helpers/tag_helper'

module ActionView
  # = Action View Asset Tag Helpers
  module Helpers #:nodoc:
    # This module provides methods for generating HTML that links views to assets such
    # as images, javascripts, stylesheets, and feeds. These methods do not verify
    # the assets exist before linking to them:
    #
    # image_tag("rails.png")
    # # => <img alt="Rails" src="/assets/rails.png" />
    # stylesheet_link_tag("application")
    # # => <link href="/assets/application.css?body=1" media="screen" rel="stylesheet" />
    module AssetTagHelper
      extend ActiveSupport::Concern

      include AssetUrlHelper
      include TagHelper
    end
  end
end