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
            opts[:host] ||= Rails.application.config.action_mailer.default_url_options[:host]
            url.#{mapping}_url(opts.merge(user_type: type_for(resource_name)))
          end
        URL_HELPERS
      end

    private
      def type_for(resource)
        slug = case resource
        when Locomotive::ContentEntry
          resource.content_type.slug
        when Locomotive::ContentType
          resource.slug
        else
          resource
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
