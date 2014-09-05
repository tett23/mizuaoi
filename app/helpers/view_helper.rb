module ViewHelper
  def breadcrumbs
    return '' if @breadcrumbs.nil?
    link_tags = begin
      @breadcrumbs.map do |breadcrumb|
        title, options= breadcrumb.values_at(:title, :options)

        options[:controller] = breadcrumb[:controller]
        options[:action] = breadcrumb[:action]

        link_to(title, options)
      end
    rescue
      nil
    end
    return '' if link_tags.blank?
    haml = <<EOS
%ul.breadcrumb
  -link_tags.each do |link_tag|
    %li
      !=link_tag
EOS

    Haml::Engine.new(haml).render(self, :link_tags=>link_tags)
  end

  def button_link(str, url, options={})
    default_confirm_message = '実行しますか？'
    attributes = {
      href: url
    }
    attributes[:class] = "#{options[:button_class]}"
    attributes[:'data-method'] = "#{options[:method].nil? ? :get : options[:method]}"
    attributes[:disabled] = true if options[:disabled]
    attributes[:'data-confirm'] = options[:confirm_message] || default_confirm_message if options[:confirm]

    options[:glyph] = 'glyph glyphicon glyphicon-'+options[:glyph].to_s unless options[:glyph].blank?

    haml = <<EOS
%button{type: 'button', class: 'btn#{options[:class]}'}
  %a{attributes}
    %span{class: '#{options[:glyph] if options.key?(:glyph)}'}
    #{str}
EOS

    Haml::Engine.new(haml).render(Object.new, :attributes=>attributes)
  end
end
