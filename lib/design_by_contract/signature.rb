require 'ripper'
class DesignByContract::Signature
  autoload :Block, 'design_by_contract/signature/block'
  autoload :Spec, 'design_by_contract/signature/spec'

  def initialize(raw_method_specs)
    @method_args_specs = raw_method_specs.map do |spec|
      DesignByContract::Signature::Spec.new(spec)
    end
  end

  def valid?(*args)
    method_args_specs.each_with_index do |spec, index|
      return false unless spec.interface.fulfilled_by?(args[index])
    end
    true
  end

  def match?(parametered_object)
    parameters_match?(parametered_object)
  end

  def ==(oth_signature)
    return false unless method_args_specs.length == oth_signature.method_args_specs.length

    method_args_specs.each_with_index do |spec, index|
      return false unless spec == oth_signature.method_args_specs[index]
    end

    true
  end

  def empty?
    method_args_specs.empty?
  end

  def raw
    @method_args_specs.map(&:raw)
  end

  protected

  attr_reader :method_args_specs

  private

  def parameters_match?(method)
    parameters = method.parameters

    req_match?(parameters) &&
      opt_match?(parameters) &&
      rest_match?(parameters) &&
      keyreq_match?(parameters) &&
      key_match?(parameters) &&
      keyrest_match?(parameters) &&
      block_match?(method)
  end

  def keyrest_match?(parameters)
    return true unless @method_args_specs.any? { |s| s.type == :keyrest }

    parameters.any? { |k, _| k == :keyrest }
  end

  def key_match?(parameters)
    optional_keywords = method_args_specs.select { |s| s.type == :key }.map(&:keyword)

    return true if optional_keywords.empty?
    actual_keys = parameters.select { |k, _| k == :key }.map { |arg_spec| arg_spec[1] }
    (optional_keywords - actual_keys).empty?
  end

  def keyreq_match?(parameters)
    expected_keys = method_args_specs.select { |s| s.type == :keyreq }.map { |s| [s.type, s.keyword] }.sort

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
    return true unless method_args_specs.any? { |s| s.type == :rest }

    parameters.any? { |k, _| k == :rest }
  end

  def arg_counts_for(parameters, type)
    expected_req_count = method_args_specs.select { |s| s.type == type }.length
    actual_req_count = parameters.map(&:first).select { |v| v == type }.length
    [expected_req_count, actual_req_count]
  end

  def block_match?(method)
    block_expected = @method_args_specs.any? { |spec| spec.type == :block }
    return true unless block_expected
    DesignByContract::Signature::Block.new(method).found? == block_expected
  end
end
