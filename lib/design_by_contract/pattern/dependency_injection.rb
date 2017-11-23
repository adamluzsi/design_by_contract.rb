class DesignByContract::Pattern::DependencyInjection
  def initialize(target_class, initialize_signature_spec)
    @target_class = target_class
    @signature = DesignByContract::Signature.new(initialize_signature_spec)
    @teardowns = []
  end

  def up
    validate_initialize_method_signature
    add_on_call_validation_hook
  end

  def down
    @teardowns.each(&:call)
    @teardowns.clear
  end

  private

  def add_on_call_validation_hook
    initialize_checker = Module.new
    signature = @signature

    initialize_checker.module_eval do
      define_method(:initialize) do |*args|
        raise(ArgumentError, 'argument signature missmatch') unless signature.valid?(*args)

        super(*args) if defined?(super)
      end
    end

    @target_class.__send__(:prepend, initialize_checker)
    @teardowns << lambda{ initialize_checker.__send__(:remove_method, :initialize) }
  end

  # TODO: signature inspect
  def validate_initialize_method_signature
    unless @signature.match?(@target_class.instance_method(:initialize))
      raise(NotImplementedError, ':initialize method signature mismatch')
    end
  rescue NameError
    unless @signature.empty?
      error_message = ":initialize method is not implemented, but contract requires one for #{@target_class}"

      raise(NotImplementedError, error_message)
    end
  end
end
