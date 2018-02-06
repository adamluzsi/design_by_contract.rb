class DesignByContract::Pattern::MethodSignatureHook < DesignByContract::Pattern::Base
  def initialize(target_method, signature_spec)
    @target_method = target_method
    raise unless @target_method.respond_to?(:owner)
    @signature = DesignByContract::Signature.new(signature_spec)
  end

  def up
    initialize_checker = Module.new
    signature = @signature
    target_method = @target_method

    initialize_checker.module_eval do
      define_method(target_method.original_name) do |*args|
        raise(ArgumentError, 'argument signature missmatch') unless signature.valid?(*args)

        super(*args) if defined?(super)
      end
    end

    target_method.owner.__send__(:prepend, initialize_checker)
    add_teardown { initialize_checker.__send__(:remove_method, :initialize) }
  end
end
