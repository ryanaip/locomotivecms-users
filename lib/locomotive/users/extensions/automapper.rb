module Locomotive
  module Users
    module Extensions
      module Automapper
        def self.included(base)
          base.prepend_before_filter :refresh_devise_mappings
          base.prepend_before_filter :set_devise_mapping
        end

        def refresh_devise_mappings
          Locomotive::ContentType.refresh_devise_mappings!
        end

        def set_devise_mapping
          key = "#{request.subdomain}_#{params[:user_type].singularize}".to_sym
          request.env['devise.mapping'] = ::Devise.mappings[key]
        end

        def content_type
          Locomotive::ContentType.where(
            slug: params[:user_type],
            site: Locomotive::Site.where(subdomain: request.subdomain).first
          ).first
        end
      end
    end
  end
end
