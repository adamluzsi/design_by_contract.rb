RSpec.shared_context :example_class do
  define_singleton_method(:example_class) do |&block|
    klass = Class.new
    klass.class_eval(&block)
    let(:example_class) { klass }
  end
end
