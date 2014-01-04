module Locomotive::Users
  class Engine < ::Rails::Engine
    initializer "locomotive.users.concerns", before: "locomotive.content_types" do
      require "locomotive/users/concerns"
    end
  end
end
