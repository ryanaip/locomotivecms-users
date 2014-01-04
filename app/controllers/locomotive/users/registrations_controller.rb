require "#{Locomotive::Users::Engine.root}/app/helpers/locomotive/users/paths"

class Locomotive::Users::RegistrationsController < Devise::RegistrationsController
  helper Locomotive::Users::Paths
  include Locomotive::Users::Extensions::Automapper

  def build_resource(hash=nil)
    template = content_type.entries.build
    resource = super(hash)
    self.resource = template
    template.attributes = template.attributes.merge(resource.attributes)
  end

protected
  def after_sign_up_path_for(resource)
    '/an/example/path'
  end
end
