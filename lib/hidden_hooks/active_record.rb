require 'active_support/concern'

module HiddenHooks
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      [
        :after_commit,
        :after_create,
        :after_create_commit,
        :after_destroy,
        :after_destroy_commit,
        :after_find,
        :after_initialize,
        :after_rollback,
        :after_save,
        :after_save_commit,
        :after_touch,
        :after_update,
        :after_update_commit,
        :after_validation,
        :before_commit,
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
