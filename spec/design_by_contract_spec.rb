require 'spec_helper'

RSpec.describe DesignByContract do
  include_context :example_class

  before { DesignByContract.forget_contract_specifications! }

  describe '.as_dependency_injection_for' do
    subject(:on_contract) { described_class.as_dependency_injection_for(example_class, arguments_specification) }

    context 'given the defensive contract flag is set because we are probably during testing' do
      before { described_class.enable_defensive_contract }

      context 'and the argument specification describes an expected argument' do
        let(:arguments_specification) do
          [
            [:req, {}],
            [:req, { info: [:req] }]
          ]
        end

        context 'and initialize block mirror this argument specification' do
          example_class do
            def initialize(value1, value2); end
          end

          context 'and new value is created from the class' do
            before { on_contract }

            it 'is called with good values' do
              l = Logger.new(STDOUT)
              t = {}

              expect { example_class.new(t, l) }.to_not raise_error
            end

            it 'is called with bad values' do
              expect { example_class.new(nil, nil) }.to raise_error ArgumentError
            end
          end
        end

        context 'and initialize is defined in the class before the contract is being made' do
          example_class do
            def initialize(value1, value2); end
          end

          it { expect { on_contract }.to_not raise_error }
        end

        context 'and there is no initialize defined in the class when contract made' do
          example_class do
          end

          it { expect { on_contract }.to raise_error NotImplementedError }

          context 'but the contract dont define any argument' do
            let(:arguments_specification) { [] }

            it { expect { on_contract }.to_not raise_error }
          end
        end
      end
    end
  end
end
