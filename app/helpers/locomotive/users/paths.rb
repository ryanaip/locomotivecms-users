module Locomotive
  module Users
    module Paths
      MAPPINGS = {
        session:           :content_type_session,
        new_session:       :new_content_type_session,

        registration:      :content_type_registration,
        new_registration:  :new_content_type_registration,

        password:          :content_type_password,
        new_password:      :new_content_type_password,

        confirmation:      :content_type_confirmation,
        new_confirmation:  :new_content_type_confirmation,
      }

      MAPPINGS.each do |method, mapping|
        class_eval <<-URL_HELPERS, __FILE__, __LINE__ + 1
          def #{method}_path(resource_name, opts={})
            url.#{mapping}_path(opts.merge(user_type: type_for(resource_name)))
          end

          def #{method}_url(resource_name, opts={})
            # TODO: This shouldn't be necessary if these are mixed into the right place
            opts[:host] ||= host_for(resource_name)
            url.#{mapping}_url(opts.merge(user_type: type_for(resource_name)))
          end
        URL_HELPERS
      end

    private
      def host_for(resource)
        base = Rails.application.config.action_mailer.default_url_options[:host]
        subdomain = subdomain_for(resource)

        subdomain ? base.gsub('*', subdomain) : base
      end

      def subdomain_for(resource)
        return nil unless Locomotive.config.multi_sites

        subdomain = case resource
        when Locomotive::ContentEntry
          resource.content_type.site.subdomain
        when Locomotive::ContentType
          resource.site.subdomain
        else
          resource.to_s.split('_').first
        end

        subdomain.to_s
      end

      def type_for(resource)
        slug = if resource.is_a?(Locomotive::ContentEntry)
          resource.content_type.slug
        elsif resource.is_a?(Locomotive::ContentType)
          resource.slug
        elsif Locomotive.config.multi_sites
          resource.to_s.split('_')[1..-1].join('_')
        else
          resource.to_s
        end

        slug.to_s.pluralize
      end

      def url
        @url ||= begin
          Rails.application.routes.url_helpers
        end
      end
    end
  end
end

ActionMailer::Base.send(:helper, Locomotive::Users::Paths)
Devise::Mailer.send(:helper, Locomotive::Users::Paths)
