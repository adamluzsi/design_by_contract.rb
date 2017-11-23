class DesignByContract::Interface
  def initialize(method_specifications)
    @method_specifications = method_specifications.reduce({}) do |ms, (name, raw_signature)|
      ms.merge(name => DesignByContract::Signature.new(raw_signature))
    end
  end

  def implemented_by?(implementator_class)
    @method_specifications.each do |name, signature|
      return false unless implementator_class.method_defined?(name)
      return false unless signature.match?(implementator_class.instance_method(name))
    end
    true
  end

  def fulfilled_by?(object)
    @method_specifications.each do |name, signature|
      return false unless object.respond_to?(name)
      return false unless signature.match?(object.method(name))
    end
    true
  end

  def match?(method)
    signature = @method_specifications[method.original_name]

    signature.match?(method)
  end

  def ==(oth_interface)
    return false unless @method_specifications.length == oth_interface.method_specifications.length

    @method_specifications.each do |name, spec|
      return false unless oth_interface.method_specifications[name] && oth_interface.method_specifications[name] == spec
    end

    return true
  end

  def raw
    @method_specifications.reduce({}) do |hash, (k,v)|
      hash.merge(k => v.raw)
    end
  end

  protected

  attr_reader :method_specifications
end
