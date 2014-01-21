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

        def devise_mapping_key
          if Locomotive.config.multi_sites
            "#{request.subdomain}_#{params[:user_type].singularize}".to_sym
          else
            params[:user_type].singularize.to_sym
          end
        end

        def set_devise_mapping
          request.env['devise.mapping'] = ::Devise.mappings[devise_mapping_key]
        end

        def content_type
          opts = { slug: params[:user_type] }
          if Locomotive.config.multi_sites
            opts[:site] = Locomotive::Site.where(subdomain: request.subdomain).first
          end

          Locomotive::ContentType.where(opts).first
        end
      end
    end
  end
end
