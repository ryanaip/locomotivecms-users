module Locomotive
  module Render
    def locomotive_default_assigns_with_users
      users = Locomotive::ContentType.where(_user: true).map do |t|
        send("current_#{t.devise_mapping}")
      end

      locomotive_default_assigns_without_users.merge(
        'end_user' => Locomotive::Liquid::Drops::CurrentUser.new(users.compact.first),
        'flash'    => Locomotive::Liquid::Drops::FlashProxy.new()
      )
    end

    alias_method_chain :locomotive_default_assigns, :users
  end
end

