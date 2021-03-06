require 'spec_helper'

RSpec.describe DesignByContract::Signature::Spec do
  subject(:spec) { described_class.new(method_arg_spec) }

  describe '#==' do
    subject(:equality) { spec == oth_spec }
    let(:oth_spec) { described_class.new(oth_method_arg_spec) }
    let(:method_arg_spec) { [:keyreq, :keyword, DesignByContract::Interface.new({})] }

    context 'when other spec is equal' do
      let(:oth_method_arg_spec) { method_arg_spec }

      it { is_expected.to be true }
    end

    context 'when other spec differ' do
      let(:oth_method_arg_spec) { method_arg_spec.dup }
      context 'by type' do
        before { oth_method_arg_spec[0] = :key }

        it { is_expected.to be false }
      end

      context 'by keyword' do
        before { oth_method_arg_spec[1] = :something_else }

        it { is_expected.to be false }
      end

      context 'by interface' do
        before { oth_method_arg_spec[2] = DesignByContract::Interface.new(oth: [:opt]) }

        it { is_expected.to be false }
      end
    end
  end

  describe '#interface' do
    subject(:interface) { spec.interface }

    context "when the method args don't mention any particullar interface" do
      let(:method_arg_spec) { :req }

      it { is_expected.to eq(DesignByContract::Interface.new({})) }

      context 'even for keyword arguments' do
        let(:method_arg_spec) { %i[keyreq key_name] }

        it { is_expected.to eq(DesignByContract::Interface.new({})) }
      end
    end

    context 'when the method args mention a particullar interface' do
      let(:given_interface) { DesignByContract::Interface.new(test: [:opt]) }
      let(:method_arg_spec) { [:req, given_interface] }

      it { is_expected.to eq(given_interface) }

      context 'even for keyword arguments' do
        let(:method_arg_spec) { [:keyreq,  :key_name, given_interface] }

        it { is_expected.to eq(given_interface) }
      end
    end

    context 'when given interface is a valid hash' do
      let(:method_arg_spec) { [:req, { test: [:opt] }] }

      it { is_expected.to eq DesignByContract::Interface.new(test: [:opt]) }
    end
  end

  describe '#type' do
    subject(:type) { spec.type }

    context 'when type is alone as the spec it self' do
      let(:method_arg_spec) { :req }

      it { is_expected.to eq :req }
    end

    context 'when type is part of the describer array as first argument' do
      let(:method_arg_spec) { [:req] }

      it { is_expected.to be :req }
    end

    context 'when not given' do
      let(:method_arg_spec) { [{}] }

      it { expect { spec }.to raise_error ArgumentError }
    end
  end

  describe '#keyword' do
    subject(:key) { spec.keyword }

    context "when the method args don't mention any particullar keyword" do
      let(:method_arg_spec) { :req }

      it { is_expected.to be nil }

      context 'and even an interface is also given' do
        let(:method_arg_spec) { [:req, {}] }

        it { is_expected.to be nil }
      end
    end

    context 'when keyword is defined' do
      %i[key keyreq].each do |key_type|
        context "when keyword type is #{key_type}" do
          let(:method_arg_spec) { [key_type, :key_name] }

          it { is_expected.to eq :key_name }

          context 'and an interface also given' do
            let(:method_arg_spec) { [:keyreq, :name_of_the_key, {}] }

            it { is_expected.to eq :name_of_the_key }
          end
        end
      end
    end
  end

  describe '#raw' do
    subject(:array_form) { spec.raw }

    context 'given simple spec provided' do
      let(:method_arg_spec) { :req }

      it { is_expected.to eq [:req, nil, {}] }
    end

    context 'given array form spec given' do
      let(:method_arg_spec) { [:req] }

      it { is_expected.to eq [:req, nil, {}] }
    end
  end
end
