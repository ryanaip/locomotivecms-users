require "#{Locomotive::Users::Engine.root}/app/helpers/locomotive/users/paths"

class Locomotive::Users::SessionsController < Devise::SessionsController
  helper Locomotive::Users::Paths
  include Locomotive::Users::Extensions::Automapper

protected

  def after_sign_in_path_for(resource)
    '/'
  end

  def after_sign_out_path_for(resource)
    '/'
  end
end
