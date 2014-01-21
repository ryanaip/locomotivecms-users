require "#{Locomotive::Users::Engine.root}/app/helpers/locomotive/users/paths"

class Locomotive::Users::ConfirmationsController < Devise::ConfirmationsController
  helper Locomotive::Users::Paths
  include Locomotive::Users::Extensions::Automapper

private

  def after_confirmation_path_for(resource_name, resource)
    '/'
  end
end
