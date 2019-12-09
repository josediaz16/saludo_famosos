class Proc
  # | Method creates a composition of two anonymous
  # functions, AKA lambdas.
  #
  # Example:
  # f = -> x { x + 2 }
  # g = -> x { x * 3 }
  # (g | f).call(3)  # -> 11; Identical to f(g(3))
  # (f | g).call(3)  # -> 15; Identical to g(f(3))
  #
  def | block
    proc { |*args| block.call self.call(*args) }
  end

  def + block
    proc { |*args| self.call(*args) + block.to_proc.call(*args) }
  end
end

class Symbol
  def | block
    self.to_proc | block
  end
end
