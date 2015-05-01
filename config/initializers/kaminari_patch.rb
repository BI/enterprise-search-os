require 'kaminari/helpers/tags'
module Kaminari
  module Helpers
    module Link

      # the link's href
      # patched so we can avoid the full params in the url, and manage the page
      # with coffeescript, adding a hidden field to the search form and submitting it
      # pass the option to the paginate helper in the view
      def url
        @options[:page_only_url] ? page.to_s : page_url_for(page)
      end

    end
  end
end
