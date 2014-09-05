class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CommonHelper

  before_filter do
    @sidebar = true
    @search = {
      query: params[:query]
    }
  end

  private
  def add_breadcrumbs(title, controller, action, options={})
    @breadcrumbs = [] if @breadcrumbs.nil?

    @breadcrumbs << {
      title: title,
      controller: controller,
      action: action,
      options: options
    }
  end

  def clear_breadcrumbs
    @breadcrumbs = []
  end
end
