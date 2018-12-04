# ActiverecordTemptable

ActiveRecordTemptable provides

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_temptable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_temptable

## Usage

`ActiveRecordTemptable.with_temptable` can be used to cache complex query's result.

For example using scheme from RailsTutorial
```ruby
ActiveRecordTemptable.with_temptable(current_user.feed) do |microposts|
  @most_microposts = microposts.group(:user_id).count
  @not_own_microposts = microposts.where.not(user_id: current_user).to_a # note that to_a is needed to load records
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/railwaymen/activerecord_temptable.
