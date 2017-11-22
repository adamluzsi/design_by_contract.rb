class DesignByContract::Signature
  def initialize(method_args_spec)
    @method_args_spec = method_args_spec
  end

  def match?(parametered_object)
    parameters_match?(parametered_object.parameters)
  end

  private

  def parameters_match?(parameters)
    req_match?(parameters) &&
      opt_match?(parameters) &&
      rest_match?(parameters) &&
      keyreq_match?(parameters) &&
      key_match?(parameters) &&
      keyrest_match?(parameters)
  end

  def keyrest_match?(parameters)
    return true unless @method_args_spec.include?(:keyrest)

    parameters.any? { |k, _| k == :keyrest }
  end

  def key_match?(parameters)
    optional_keys = @method_args_spec.select { |k| k.is_a?(Array) && k[0] == :key }.map { |arg_spec| arg_spec[1] }
    return true if optional_keys.empty?
    actual_keys = parameters.select { |k, _| k == :key }.map { |arg_spec| arg_spec[1] }
    (optional_keys - actual_keys).empty?
  end

  def keyreq_match?(parameters)
    expected_keys = @method_args_spec.select { |k| k.is_a?(Array) && k[0] == :keyreq }.sort
    return true if expected_keys.empty?
    actual_keys = parameters.select { |k, _| k == :keyreq }.sort
    expected_keys == actual_keys
  end

  def req_match?(parameters)
    expected_req, actually_req = arg_counts_for(parameters, :req)
    expected_opt, actually_opt = arg_counts_for(parameters, :opt)
    return true if expected_req.zero?
    expected_req <= actually_req + actually_opt && actually_req <= expected_req
  end

  def opt_match?(parameters)
    expected, actually = arg_counts_for(parameters, :opt)
    return true if expected.zero?
    expected <= actually
  end

  def rest_match?(parameters)
    return true unless @method_args_spec.include?(:rest)

    parameters.any? { |k, _| k == :rest }
  end

  def arg_counts_for(parameters, type)
    expected_req_count = @method_args_spec.select { |v| v == type }.length
    actual_req_count = parameters.map(&:first).select { |v| v == type }.length
    [expected_req_count, actual_req_count]
  end
end
