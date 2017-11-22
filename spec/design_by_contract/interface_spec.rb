require 'spec_helper'

RSpec.describe DesignByContract::Interface do
  subject(:interface) { described_class.new(method_specifications) }

  describe '#implemented_by?' do
    subject(:implementation_state) { interface.implemented_by?(example_class) }

    include_context :example_class
    include_examples :how_to_specify_method_specification
  end

  describe '#fulfilled_by?' do
    subject(:object_contract_acceptance) { interface.fulfilled_by?(example_class.new) }

    include_context :example_class
    include_examples :how_to_specify_method_specification
  end

  describe '#parameters_match?' do
    subject(:parameter_match_state) { interface.match?(method_object) }

    let(:method_object) do
      instance = example_class.new
      instance.method(:test)
    end

    include_context :example_class
    include_examples :how_to_specify_method_specification
  end

  describe '#==' do
    subject(:equality) { interface == oth_interface }

    context 'when other interface is equal by terms of content' do
      let(:method_specifications) { { test: [:req] } }
      let(:oth_interface) { described_class.new(method_specifications) }

      it { is_expected.to be true }
    end
  end
end
