require 'spec_helper'

RSpec.describe DesignByContract::Signature do
  subject(:checker) { described_class.new(signature) }

  describe '#match?' do
    subject(:acceptance) { checker.match?(method) }

    let(:method) do
      instance = example_class.new
      instance.method(:test)
    end

    include_examples :how_to_specify_method_signature
  end
end
