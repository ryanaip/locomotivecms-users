require "#{Locomotive::Users::Engine.root}/app/helpers/locomotive/users/paths"

class Locomotive::Users::PasswordsController < Devise::PasswordsController
  helper Locomotive::Users::Paths
  include Locomotive::Users::Extensions::Automapper
end
