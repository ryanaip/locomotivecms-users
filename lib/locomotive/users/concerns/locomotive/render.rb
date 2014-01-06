module Locomotive
  module Render
    def logged_in_end_user
      users = Locomotive::ContentType.where(_user: true).map do |t|
        send("current_#{t.devise_mapping}")
      end

      users.compact.first
    end

    def locomotive_default_assigns_with_users
      locomotive_default_assigns_without_users.merge(
        'end_user' => Locomotive::Liquid::Drops::CurrentUser.new(logged_in_end_user),
        'flash'    => Locomotive::Liquid::Drops::FlashProxy.new()
      )
    end

    alias_method_chain :locomotive_default_assigns, :users
  end
end

