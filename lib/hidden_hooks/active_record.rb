require 'active_support/concern'

module HiddenHooks
  module ActiveRecord
    extend ActiveSupport::Concern

    class_methods do
      def inherited subclass
        super

        [
          :after_commit,
          :after_create,
          :after_destroy,
          :after_find,
          :after_initialize,
          :after_rollback,
          :after_save,
          :after_touch,
          :after_update,
          :after_validation,
          :before_commit,
          :before_create,
          :before_destroy,
          :before_save,
          :before_update,
          :before_validation
        ].each do |callback|
          subclass.send callback, HiddenHooks[subclass], prepend: true
        end
      end
    end
  end
end
