require 'will_paginate/view_helpers/action_view'

module WillPaginate
  module ActionView
    def will_paginate(collection = nil, options = {})
      options = options.merge(
        renderer: WillPaginate::ActionView::BootstrapLinkRenderer,
        class: 'pagination justify-content-center',
        inner_window: 1, 
        outer_window: 1  
      )
      super(collection, options)
    end

    class BootstrapLinkRenderer < LinkRenderer 
      public

      def html_container(html)
        tag(:nav, tag(:ul, html, class: 'pagination mt-4'))
      end

      def page_number(page)
        if page == current_page
          tag(:li, tag(:span, page, class: 'page-link'), class: 'page-item active')
        else
          tag(:li, link(page, page, class: 'page-link'), class: 'page-item')
        end
      end

      def previous_or_next_page(page, text, classname, options = {})
        if page
          tag(:li, link(text, page, class: 'page-link'), class: 'page-item')
        else
          tag(:li, tag(:span, text, class: 'page-link'), class: 'page-item disabled')
        end
      end
    end
  end
end