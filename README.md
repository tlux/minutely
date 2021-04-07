# DayTime

Classes for representing the time of a day by using only hours and minutes. This
is particularly useful when implementing business logic that has to deal with
opening times.

## Installation

Please ensure to use the i22 Gem server in your local project. The Gemfile.lock

Add this line to your application's Gemfile:

```ruby
gem 'day_time'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install day_time
```

## Usage

### Time

Create a new day time:

```ruby
time1 = DayTime::Time.new(21, 42)
time1.to_s # => "21:42"

time2 = DayTime::Time.new(9, 3)
time2.to_s # => "09:03"
```

Parse day time using `DateTime`, `Time`, `String` or `Integer`:

```ruby
DayTime::Time.parse(DateTime.now)
DayTime::Time.parse(Time.now)
DayTime::Time.parse("9:03").to_s # => "09:03"
DayTime::Time.parse(903).to_s # => "09:03"
```

Get the next minute:

```ruby
time = DayTime::Time.parse("9:03")
time.succ.to_s # => "9:04"
```

Compare and sort by times:

```ruby
time1 = DayTime::Time.parse('9:03')
time2 = DayTime::Time.parse('21:42')

time1 == time2 # => false
time1 < time2 # => true
time1 <= time2 # => true
time1 >= time2 # => false
time1 > time2 # => false

[
  DayTime::Time.parse('21:42'),
  DayTime::Time.parse('9:03'),
  DayTime::Time.parse('15:00')
].sort.map(&:to_s) # => ["09:03", "15:00", "21:42"]
```

### Time Range

Create a new time range:

```ruby
start_time = DayTime::Time.new(9, 3)
end_time = DayTime::Time.new(21, 42)

DayTime::TimeRange.new(start_time, end_time).to_s # => "09:03-21:42"
```

Parse time range using `String`:

```ruby
DayTime::TimeRange.parse('9:03-21:42')
```

Parse time range using `Hash`:

```ruby
DayTime::TimeRange.parse(from: '9:03', to: '21:42')
```

Check whether time range includes time:

```ruby
range = DayTime::TimeRange.parse(from: '9:03', to: '21:42')

range.include?('10:00') # => true
range.include?('22:00') # => false
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Run
`bundle exec rspec` to run the tests. Linting an formatting are supported using
`bundle exec rubocop`. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on the [internal i22
GitLab](https://gitlab.i22.de/pakete/ruby/day_time).
