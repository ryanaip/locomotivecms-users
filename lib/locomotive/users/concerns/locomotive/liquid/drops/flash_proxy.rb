module Locomotive
  module Liquid
    module Drops

      class FlashProxy < SessionProxy

        def before_method(meth)
          flash = super(:flash)
          flash[meth.to_sym] if flash.present?
        end

      end
    end
  end
end
