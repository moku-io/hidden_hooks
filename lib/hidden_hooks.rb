require_relative 'hidden_hooks/version'

require 'active_support/core_ext/module/attribute_accessors'

module HiddenHooks
  mattr_reader :hooks,
               default: Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = [] } },
               instance_accessor: false,
               instance_reader: false

  class SetUpProxy
    private

    def method_missing hook, klass, &block
      ::HiddenHooks.hooks[klass][hook] << block
    end

    def respond_to_missing? _, _=false
      true
    end
  end

  class LookUpProxy
    def initialize klass
      @hooks = ::HiddenHooks.hooks[klass]
    end

    private

    def method_missing(hook, *args, **kwargs, &block)
      @hooks[hook].each { _1.call(*args, **kwargs, &block) }
    end

    def respond_to_missing? _, _=false
      true
    end
  end

  def self.hook_up(&block)
    SetUpProxy.new.instance_exec(&block)
  end

  def self.[] klass
    LookUpProxy.new klass
  end
end

require_relative 'hidden_hooks/active_record'
