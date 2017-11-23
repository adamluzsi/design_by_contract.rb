module DesignByContract
  extend(self)

  autoload :Interface, 'design_by_contract/interface'
  autoload :Pattern, 'design_by_contract/pattern'
  autoload :Signature, 'design_by_contract/signature'

  def forget_contract_specifications!
    contracts.keys.each(&:down)
    contracts.clear
    nil
  end

  def enable_defensive_contract
    @defensive_contract = true
    fulfill_contracts!
  end

  def as_dependency_injection_for(klass, initialize_signature_spec)
    register_contract DesignByContract::Pattern::DependencyInjection.new(klass, initialize_signature_spec)
  end

  private

  def contracts
    @__contracts__ ||= {}
  end

  def register_contract(contract)
    contracts[contract] = :inactive
    fulfill_contracts! if @defensive_contract
  end

  def fulfill_contracts!
    contracts.each do |contract, state|
      next if state == :active
      contract.up
      contracts[contract] = :active
    end
  end
end
