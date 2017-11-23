module T
  def t
    puts 'T'
    super
 end
end

class Z
  def t
    puts 'Z'
 end
end

p Z.instance_method(:t).source_location
Z.prepend(T)
p Z.instance_method(:t).source_location
p Z.instance_method(:t).super_method

Z.new.t

p Z.instance_method(:t).source_location

class M
  def initialize(i_am_just_an_illusion); end

  def method1(what_the_fuck); end
end

p M.method_defined?(:initialize) #=> false
p M.method_defined?(:method1) #=> true

# method_defined?
# Returns true if the named method is defined by mod
# (or its included modules and, if mod is a class, its ancestors).
# Public and protected methods are matched.
