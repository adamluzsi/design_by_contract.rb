require 'ripper'

class DesignByContract::Signature::Block
  def initialize(target_method)
    @target_method = target_method
  end

  def found?
    as_parameter? || as_yield?
  end

  private

  def as_parameter?
    parameters = @target_method.parameters
    parameters.map(&:first).include?(:block)
  end

  def as_yield?
    file_path, line_number = @target_method.source_location
    return false unless file_path && line_number
    return false unless File.exist?(file_path)

    sexp = Ripper.sexp(File.read(file_path))
    yield_match?(sexp, line_number)
  end

  METHOD_DEFINE_KEYWORDS = [
    'define_method',
    'define_singleton_method',
    'define_instance_method',
    :def
  ].freeze

  def yield_match?(sexp, line_number)
    stack = []
    create_stack_to(sexp, stack) { |a| a[0] == line_number }

    method_sexp = find_sexp_from(stack) do |s|
      METHOD_DEFINE_KEYWORDS.any?{|token| s.include?(token) }
    end

    method_sexp.flatten.include?(:yield0)
  end

  def find_sexp_from(stack)
    stack.length.times do |i|
      at_index = (i + 1) * -1
      sexp = stack[at_index]
      return sexp if yield(sexp)
    end
    nil
  end

  def create_stack_to(sexp, stack = [], &block)
    stack << sexp
    return true if yield(sexp)

    sexp.each do |v|
      next unless v.is_a?(Array)

      return true if create_stack_to(v, stack, &block)

      stack.pop
    end

    false
  end
end
