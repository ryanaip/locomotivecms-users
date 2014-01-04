module Locomotive
  module Users
    module Extensions
      module Automapper
        def self.included(base)
          base.prepend_before_filter :set_devise_mapping
        end

        def set_devise_mapping
          key = params[:user_type].singularize.to_sym
          request.env['devise.mapping'] = ::Devise.mappings[key]
        end

        def content_type
          Locomotive::ContentType.where(slug: params[:user_type]).first
        end
      end
    end
  end
end
