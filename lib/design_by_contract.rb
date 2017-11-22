module DesignByContract
  extend(self)
  autoload :Interface, 'design_by_contract/interface'
  autoload :Signature, 'design_by_contract/signature'

  def enable_defensive_contract
    @defensive_contract = true
  end

  def dependency_injection(klass, arg_spec)
    return unless @defensive_contract

    interfaces = arg_spec.map{ |spec| DesignByContract::Interface.new(spec) }

    signature_checker = Module.new
    signature_checker.module_eval do
      def method_added(name)
        return unless name == :initialize
        instance_method(:initialize).parameters.length


      end
    end

    initialize_checker = Module.new
    initialize_checker.module_eval do
      # def initialize(*args)
      #   args.each do |arg|

      #   end

      #   super if defined?(super)
      # end
    end


  end
end
