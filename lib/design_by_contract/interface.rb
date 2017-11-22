class DesignByContract::Interface
  REQUIRED_ARGUMENT = :req
  OPTIONAL_ARGUMENT = :opt
  REST_OF_THE_ARGUMENTS = :rest

  REQUIRED_KEYWORD = :keyreq
  OPTIONAL_KEYWORD = :key
  AFTER_KEYWORD_ARGUMENTS = :keyrest

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

end
