require_relative 'hidden_hooks/version'

require_relative 'hidden_hooks/at_least_one_hook_required'
require_relative 'hidden_hooks/sole_hook_exceeded'

require 'active_support/core_ext/module/attribute_accessors'

module HiddenHooks
  mattr_reader :hooks,
               default: Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = [] } },
               instance_accessor: false,
               instance_reader: false

  class SetUpProxy
  private

    def method_missing hook, klass=nil, context: nil, &block
      ::HiddenHooks.hooks[klass][hook] << if context.nil?
                                            block
                                          else
                                            proc do |*args, **kwargs, &hook_block|
                                              context
                                                .call(*args, **kwargs, &hook_block)
                                                .instance_exec(*args, hook_block, **kwargs, &block)
                                            end
                                          end
    end

    def respond_to_missing? _, _=false
      true
    end
  end

  class LookUpProxy
    def initialize klass=nil, sole: false, present: sole
      @klass = klass
      @hooks = ::HiddenHooks.hooks[klass]
      @sole = sole
      @present = present
    end

  private

    def method_missing(hook_name, *args, **kwargs, &block)
      hooks = @hooks[hook_name]

      if @present && hooks.empty?
        raise HiddenHooks::AtLeastOneHookRequired,
              "There must be at least one hook `#{hook_name}` defined for class `#{@klass}`"
      end

      if @sole && hooks.size > 1
        raise HiddenHooks::SoleHookExceeded,
              "There must be at most one hook `#{hook_name}` defined for class `#{@klass}`"
      end

      hooks
        .map { |hook| hook.call(*args, **kwargs, &block) }
        .then { |results| (@sole && @present) ? results.first : results }
    end

    def respond_to_missing? _, _=false
      true
    end
  end

  def self.hook_up &block
    SetUpProxy.new.instance_exec(&block)
  end

  def self.[](...)
    LookUpProxy.new(...)
  end
end

require_relative 'hidden_hooks/active_record'
