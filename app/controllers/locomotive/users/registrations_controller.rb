require "#{Locomotive::Users::Engine.root}/app/helpers/locomotive/users/paths"

class Locomotive::Users::RegistrationsController < Devise::RegistrationsController
  helper Locomotive::Users::Paths
  include Locomotive::Users::Extensions::Automapper

  def build_resource(hash=nil)
    template = content_type.entries.build
    resource = super(hash)
    self.resource = template
    template.attributes = template.attributes.merge(resource.attributes)

    # Password and password_confirmation are never stored in attributes
    resource_params = params.fetch(devise_mapping_key, {})
    template.password = resource_params[:password]
    template.password_confirmation = resource_params[:password_confirmation]
  end

private

  def after_sign_up_path_for(resource)
    '/'
  end

  def after_inactive_sign_up_path_for(resource)
    '/'
  end
end
