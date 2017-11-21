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

### Interface

The most basic simple usecase for interface is to use it for simply validate a class

```ruby

i = DesignByContract::Interface.new test: [:req, :opt, %i[keyreq keyword] ]

class T
  def test(value, value_with_default="def", keyword:)
  end
end

i.implemented_by?(T) #=> true
i.implemented_by?(Class) #=> false

```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/design_by_contract. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DesignByContract project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/design_by_contract/blob/master/CODE_OF_CONDUCT.md).
