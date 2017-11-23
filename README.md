# DesignByContract

This is a collection of techniques to create contract between Objects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'design_by_contract'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install design_by_contract

## Usage

### Design pattern fulfilling methods

This are created to increase productivity and, make test fail fast in order to eliminate unwanted hiccup

#### Dependency Injection Pattern

interfaces in dependency injection contract placed as last element in the argument description array.
For key or keyreq arguments, it is required to specify the keyword as second parameter for argument description element.

```ruby

require 'logger'
class T

  StoreInterface = DesignByContract::Interface.new(create: [:req, :req], read: [:req])

  def initialize(store, logger: Logger.new(STDOUT))
  end

end

DesignByContract.as_dependency_injection_for T, [
    [:req, StoreInterface], # pass as predefined interfaces
    [:key, :logger, {info: [:req, :block]}] # or as raw hash based signature
]

```

### Under the Hood components

#### Signature

Signatures are the fingerprint of a function.
It can describe how the method should look.
This normally just part of the convention methods under the hood.


```ruby

s = DesignByContract::Signature.new [:req, :opt, %i[keyreq keyword] ]

def test(value, value_with_default="def", keyword:)
end

s.match?(method(:test)) #=> true

```

#### Interface

The most basic simple use case for interface is to use it for simply validate a class.
Other than that it's also just only the part of the convention methods under the hood.

```ruby

i = DesignByContract::Interface.new test: [:req, %i[keyreq keyword] ]

class Good1
  def test(value, value_with_default="def", keyword:)
  end
end

class Good2
  def test(value, keyword:)
  end
end

class Good3
  def test(value="with_def_still_ok_for_req", keyword:)
  end
end

class Bad
  def test(value1, value2, keyword:)
  end
end

i.implemented_by?(Good1) #=> true
i.fulfilled_by?(Good1.new) #=> true
i.match?(Good1.new.method(:test)) #=> true

i.implemented_by?(Good2) #=> true
i.fulfilled_by?(Good2.new) #=> true
i.match?(Good2.new.method(:test)) #=> true

i.implemented_by?(Good3) #=> true
i.fulfilled_by?(Good3.new) #=> true
i.match?(Good3.new.method(:test)) #=> true

i.implemented_by?(Bad) #=> false
i.fulfilled_by?(Bad.new) #=> false
i.match?(Bad.new.method(:test)) #=> false

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/design_by_contract. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DesignByContract project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/design_by_contract/blob/master/CODE_OF_CONDUCT.md).
