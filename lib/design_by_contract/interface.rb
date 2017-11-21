class DesignByContract::Interface
  REQUIRED_ARGUMENT = :req
  OPTIONAL_ARGUMENT = :opt
  REST_OF_THE_ARGUMENTS = :rest

  REQUIRED_KEYWORD = :keyreq
  OPTIONAL_KEYWORD = :key
  AFTER_KEYWORD_ARGUMENTS = :keyrest

  def initialize(method_specifications)
    @method_specifications = method_specifications
  end

  def implemented_by?(implementator_class)
    @method_specifications.each do |name, signature|
      return false unless implementator_class.method_defined?(name)

      parameters = implementator_class.instance_method(name).parameters
      return false unless signature_match?(parameters, signature)
    end
    true
  end

  def fulfilled_by?(object)
    @method_specifications.each do |name, signature|
      return false unless object.respond_to?(name)

      parameters = object.method(name).parameters
      return false unless signature_match?(parameters, signature)
    end
    true
  end

  private

  def signature_match?(parameters, signature)
    req_match?(parameters, signature) &&
      opt_match?(parameters, signature) &&
      rest_match?(parameters, signature) &&
      keyreq_match?(parameters, signature) &&
      key_match?(parameters, signature) &&
      keyrest_match?(parameters, signature)
  end

  def keyrest_match?(parameters, signature)
    return true unless signature.include?(:keyrest)

    parameters.any? { |k, _| k == :keyrest }
  end

  def key_match?(parameters, signature)
    optional_keys = signature.select { |k| k.is_a?(Array) && k[0] == :key }.map(&:last)
    return true if optional_keys.empty?
    actual_keys = parameters.select { |k, _| k == :key }.map(&:last)
    (optional_keys - actual_keys).empty?
  end

  def keyreq_match?(parameters, signature)
    expected_keys = signature.select { |k| k.is_a?(Array) && k[0] == :keyreq }.sort
    return true if expected_keys.empty?
    actual_keys = parameters.select { |k, _| k == :keyreq }.sort
    expected_keys == actual_keys
  end

  def req_match?(parameters, signature)
    expected, actually = arg_counts_for(parameters, signature, :req)
    return true if expected == 0
    expected == actually
  end

  def opt_match?(parameters, signature)
    expected, actually = arg_counts_for(parameters, signature, :opt)
    return true if expected == 0
    expected <= actually
  end

  def rest_match?(parameters, signature)
    return true unless signature.include?(:rest)

    parameters.any? { |k, _| k == :rest }
  end

  def arg_counts_for(parameters, signature, type)
    expected_req_count = signature.select { |v| v == type }.length
    actual_req_count = parameters.map(&:first).select { |v| v == type }.length
    [expected_req_count, actual_req_count]
  end
end
