require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_type').to_s

Locomotive::ContentType.class_eval do
  scope :user_types, where(_user: true)

  field :_user, type: Boolean, default: false

  after_save :add_devise_mapping!

  def self.user_type_names
    user_types.pluck(:slug)
  end

  def self.refresh_devise_mappings!
    user_types.each(&:add_devise_mapping!)
  end

  def devise_mapping
    slug.singularize.to_sym
  end

  def add_devise_mapping!
    return if !_user or Devise.mappings.has_key?(devise_mapping)

    Devise.add_mapping devise_mapping, class_name: 'Locomotive::ContentEntry'

    # Required because Devise only adds mappings to warden on finalize, rather than
    # when add_mapping is called.
    #
    # TODO: Find a way around this, or submit a change to Devise that exposes
    # this functionality. (See Devise.configure_warden!)
    mapping = Devise.mappings[devise_mapping]
    Devise.warden_config.scope_defaults mapping.name, :strategies => mapping.strategies

    Devise.warden_config.serialize_into_session(mapping.name) do |record|
      mapping.to.serialize_into_session(record)
    end

    Devise.warden_config.serialize_from_session(mapping.name) do |key|
      # Previous versions contained an additional entry at the beginning of
      # key with the record's class name.
      args = key[-2, 2]
      mapping.to.serialize_from_session(*args)
    end
  end
end
