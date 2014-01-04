require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_type').to_s

Locomotive::ContentType.class_eval do
  field :_user, type: Boolean, default: false

  after_save :add_devise_mapping!

  def devise_mapping
    slug.singularize.to_sym
  end

  def add_devise_mapping!
    return if !_user or Devise.mappings.has_key?(devise_mapping)

    Devise.add_mapping devise_mapping, class_name: 'Locomotive::ContentEntry'
  end
end
