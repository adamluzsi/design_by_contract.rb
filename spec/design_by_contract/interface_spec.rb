require 'spec_helper'

RSpec.describe DesignByContract::Interface do
  subject(:interface) { described_class.new(method_specifications) }

  describe '#implemented_by?' do
    subject(:implementation_state) { interface.implemented_by?(example_class) }

    include_context :example_class

    context 'when method specifications describe a single method' do
      let(:method_specifications) { { test: signature } }

      context 'and the signature includes a req' do
        let(:signature) { [:req] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(value); end
          end

          it { is_expected.to be true }

          context 'and optional values are accepted after the requred part matching' do
            specify_example_class do
              def test(value, arg_with_default = 'default_value'); end
            end

            it { is_expected.to be true }
          end
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(value = 'default_value'); end
          end

          it { is_expected.to be false }
        end
      end

      context 'and the signature includes a opt' do
        let(:signature) { %i[req opt] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(value, value_with_def = 'expected_default_value'); end
          end

          it { is_expected.to be true }

          context 'when multiple opt method defined in the actually method' do
            specify_example_class do
              def test(value, first_value_with_def = 1, second_value_with_def = 2); end
            end

            it { is_expected.to be true }
          end
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(value); end
          end

          it { is_expected.to be false }
        end
      end

      context 'and the signature includes a rest' do
        let(:signature) { %i[req rest] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(value, *more_values); end
          end

          it { is_expected.to be true }
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(one_value_no_rest); end
          end

          it { is_expected.to be false }
        end
      end

      context 'and the signature includes a required keyword' do
        let(:signature) { [%i[keyreq expected_key]] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(expected_key:); end
          end

          it { is_expected.to be true }

          context 'and keyword that optional are accepted' do
            specify_example_class do
              def test(expected_key:, opts: {}); end
            end

            it { is_expected.to be true }

            context 'even if the keyword order not match exactly the signature order' do
              specify_example_class do
                def test(opts: {}, expected_key:); end
              end

              it { is_expected.to be true }
            end
          end
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(something:); end
          end

          it { is_expected.to be false }
        end
      end

      context 'and the signature includes an optional keyword' do
        let(:signature) { [%i[key optional_keyword]] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(optional_keyword: nil); end
          end

          it { is_expected.to be true }

          context 'and keyword that optional are accepted' do
            specify_example_class do
              def test(opts: {}, optional_keyword: nil); end
            end

            it { is_expected.to be true }

            context 'even if the keyword order not match exactly the signature order' do
              specify_example_class do
                def test(opts: {}, optional_keyword: nil); end
              end

              it { is_expected.to be true }
            end
          end
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(something: nil); end
          end

          it { is_expected.to be false }
        end
      end

      context 'and the signature includes a keyrest' do
        let(:signature) { [%i[key optional_keyword], :keyrest] }

        context 'and the example class implements this specification' do
          specify_example_class do
            def test(optional_keyword: nil, **rest); end
          end

          it { is_expected.to be true }
        end

        context 'and the example class not implements the required specification' do
          specify_example_class do
            def test(optional_keyword: nil); end
          end

          it { is_expected.to be false }
        end
      end
    end
  end
end
