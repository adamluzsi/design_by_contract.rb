
RSpec.shared_examples :how_to_specify_method_specification do
  context 'when method specifications describe a single method' do
    let(:method_specifications) { { test: signature } }

    include_examples :how_to_specify_method_signature
  end
end
