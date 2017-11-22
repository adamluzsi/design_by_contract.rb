require 'spec_helper'

RSpec.describe DesignByContract do
  include_context :example_class
  describe '.dependency_injection' do
    subject(:after_specification) { described_class.dependency_injection(example_class, arguments_specification) }

    context 'given the defensive contract flag is set because we are probably during testing' do
      before { described_class.enable_defensive_contract }

      context 'and the argument specification describes an expected argument' do
        let(:arguments_specification) { [{ test: [] }, { value: [] }] }

        context 'and initialize block mirror this argument specification' do
          example_class do
            def initialize(value1, value2); end
          end

          it { expect { after_specification }.to_not raise_error }
        end

        context 'and initialize block mirror this argument specification' do
          example_class do
            def initialize(value1, value2); end
          end

          it "will be ok, because initialize implements the contract" do
            after_specification

            expect { example_class.class_eval{ def initialize(value1, value2); end } }.to_not raise_error
          end
        end

        context 'and initialize block different from the specification' do
          example_class do
          end

          xit "will be ok, because initialize implements the contract" do
            after_specification

            expect { example_class.class_eval{ def initialize(value1); end } }.to raise_error NotImplementedError
          end
        end
      end
    end
  end
end
