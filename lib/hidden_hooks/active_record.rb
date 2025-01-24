require 'active_support/concern'

module HiddenHooks
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      [
        :after_create,
        :after_destroy,
        :after_find,
        :after_initialize,
        :after_save,
        :after_touch,
        :after_update,
        :after_validation,
        :before_create,
        :before_destroy,
        :before_save,
        :before_update,
        :before_validation
      ].each do |callback|
        send callback, HiddenHooks[self], prepend: true
      end
    end
  end
end
