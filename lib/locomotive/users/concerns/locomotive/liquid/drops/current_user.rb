module Locomotive
  module Liquid
    module Drops
      class CurrentUser

        def type
          return unless logged_in?

          case @_source
          when Locomotive::Account
            '_admininstrator'
          else
            @_source.content_type.slug.to_s.singularize
          end
        end

      end
    end
  end
end
