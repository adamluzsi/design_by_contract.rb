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

  describe '#valid?' do
    subject(:validity) { checker.valid?(*arguments) }
    let(:signature) { [:req, [:req, { info: [:req] }]] }

    context 'when passed argument list is valid for the given signature' do
      let(:arguments) { ['anything', Logger.new(STDOUT)] }

      it { is_expected.to be true }
    end

    context 'when passed argument not fullfill the signature requirement' do
      let(:arguments) { %w[anything oth] }

      it { is_expected.to be false }
    end
  end

  describe '#empty?' do
    subject(:emptiness) { checker.empty? }

    context 'when specified signature is actually contain nothing' do
      let(:signature) { [] }

      it { is_expected.to be true }
    end

    context 'when specified signature is including requirements' do
      let(:signature) { [:opt] }

      it { is_expected.to be false }
    end
  end

  describe '#raw' do
    subject(:array_form) { checker.raw }

    context 'given the specification is not empty' do
      let(:signature) { [:req, [:key, :test, { test: [:req] }]] }

      it { is_expected.to eq [[:req, nil, {}], [:key, :test, { test: [[:req, nil, {}]] }]] }
    end
  end
end
