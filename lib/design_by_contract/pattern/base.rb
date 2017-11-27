class DesignByContract::Pattern::Base
  def up
    raise(NotImplementedError)
  end

  def down
    teardowns.each(&:call)
    teardowns.clear
    nil
  end

  protected

  def teardowns
    @__teardowns__ ||= []
  end

  def add_teardown(&block)
    teardowns << block
  end
end
