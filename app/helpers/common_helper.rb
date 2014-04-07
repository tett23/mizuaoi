module CommonHelper
  def url(controller, action, options={})
    url_params = {
      controller: controller,
      action: action
    }.merge(options)
    url_for(url_params)
  end
end
