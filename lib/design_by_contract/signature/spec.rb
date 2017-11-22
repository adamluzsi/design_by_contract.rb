class DesignByContract::Signature::Spec
  attr_reader :type, :keyword, :interface

  def initialize(method_args_spec)
    @type, @keyword, @interface = format(method_args_spec)
  end

  def ==(oth_spec)
    type == oth_spec.type &&
      keyword == oth_spec.keyword &&
      interface == oth_spec.interface
  end

  private

  def format(spec)
    spec = [spec] unless spec.is_a?(::Array)

    case spec.length
    when 1
      return parse_type(spec[0]), nil, parse_interface(nil)
    when 2
      return parse_type(spec[0]), parse_keyword(spec[1]), parse_interface(spec[1])
    when 3
      return parse_type(spec[0]), parse_keyword(spec[1]), parse_interface(spec[2])
    else
      raise(NotImplementedError)
    end
  end

  ACCEPTED_TYPES = %i[req opt rest keyreq key keyreq keyrest block].freeze

  def parse_type(object)
    unless ACCEPTED_TYPES.include?(object)
      raise(ArgumentError, 'only the following types are accepted: ' + ACCEPTED_TYPES.join(', '))
    end

    object
  end

  def parse_keyword(object)
    case object
    when ::Symbol, ::NilClass
      return object
    when ::Hash, DesignByContract::Interface
      return nil
    else
      raise(ArgumentError, 'keyword can only be symbol')
    end
  end

  def parse_interface(object)
    case object
    when DesignByContract::Interface
      object
    when ::Hash
      DesignByContract::Interface.new(object)
    when ::NilClass, ::Symbol
      DesignByContract::Interface.new({})
    else
      raise(ArgumentError, 'interface can only be hash or interface type')
    end
  end
end
