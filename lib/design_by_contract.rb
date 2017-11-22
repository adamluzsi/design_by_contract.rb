module DesignByContract
  extend(self)
  autoload :Interface, 'design_by_contract/interface'
  autoload :Signature, 'design_by_contract/signature'

  def enable_defensive_contract
    @defensive_contract = true
    fulfill_contracts!
  end

  def as_dependency_injection_for(klass, initialize_signature_spec)
    register_contract do
      signature = DesignByContract::Signature.new(initialize_signature_spec)

      if klass.method_defined?(:initialize)
        signature.match?(klass.instance_method(:initialize))
      end

      signature_checker = Module.new
      signature_checker.module_eval do
        define_method(:method_added) do |name|
          super(name) if defined?(super)

          if name == :initialize
            raise(NotImplementedError) unless signature.match?(klass.instance_method(:initialize))
          end

        end
      end

      metaclass = class << klass; self; end
      metaclass.__send__(:prepend, signature_checker)

      # initialize_checker = Module.new
      # initialize_checker.module_eval do
      #   define_method(:initialize) do |*args|
      #   end
      # end
    end
  end

  private

  def contracts
    @__contracts__ ||= {}
  end

  def register_contract(&contract)
    contracts[contract] = :inactive
    fulfill_contracts! if @defensive_contract
  end

  def fulfill_contracts!
    contracts.each do |contract, state|
      next if state == :active
      contract.call
      contracts[contract] = :active
    end
  end
end
