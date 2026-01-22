# frozen_string_literal: true

module Blog
  class LayoutComponent < ViewComponent::Base
    renders_one :sidebar

    def initialize(show_sidebar: true)
      @show_sidebar = show_sidebar
    end

    def show_sidebar?
      @show_sidebar && sidebar?
    end
  end
end
