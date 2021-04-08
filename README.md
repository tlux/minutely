# DayTime

Classes for representing the time of a day by using only hours and minutes. This
is particularly useful when implementing business logic that has to deal with
opening times.

## Installation

Please ensure to use the i22 Gem server in your local project. Add the following
line to the top of your Gemfile.

```ruby
source 'http://gems.dev.i22.de/'
```

After that, add this line to your Gemfile:

```ruby
gem 'day_time'
```

Then execute:

```sh
bundle install
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
DayTime::Time.parse('9:03').to_s # => "09:03"
DayTime::Time.parse(903).to_s # => "09:03"
```

Get the next minute:

```ruby
time = DayTime::Time.parse('9:03')
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

Native Range support:

```ruby
(DayTime::Time.parse('9:57')..DayTime::Time.parse('10:10'))

```

### Time Range

A special type of day time range, that also allows defining ranges spanning over
12 am (0:00).

Create a new time range:

time1 = DayTime::Time.new(9, 3)
```ruby
time2 = DayTime::Time.new(21, 42)

DayTime::TimeRange.new(time1, time2).to_s # => "09:03-21:42"
DayTime::TimeRange.new(time2, time1).to_s # => "21:42-09:03"
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
range = DayTime::TimeRange.new('9:03', '21:42')

range.include?('10:00') # => true
range.include?('22:00') # => false
```

Convert to Ruby `Range`:

```ruby
DayTime::TimeRange.new('9:03', '21:42').to_r
# => #<DayTime::Time @hour=9, @minute=3>..#<DayTime::Time @hour=21, @minute=42>
```

Convert to Array of `DayTime::Time`s:

```ruby
DayTime::TimeRange.new('23:57', '0:03').to_a.map(&:to_s)
# => ["23:57", "23:58", "23:59", "00:00", "00:01", "00:02", "00:03"]
```

Note this is only possible with ranges not spanning midnight.

## Development

After checking out the repo, run `bundle install` to install dependencies. Run
`bundle exec rspec` to run the tests. Linting an formatting are supported using
`bundle exec rubocop`. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To publish the Gem:

1. Update the version in `lib/day_time/version.rb`

2. Create and push a tag representing the new Gem version:

   ```sh
   git tag v1.2.3
   git push --tag
   ```

3. Run the publish script to build the Gem and push it to the server:

   ```sh
   ./bin/publish
   ```

## Contributing

Bug reports and pull requests are welcome on the [internal i22
GitLab](https://gitlab.i22.de/pakete/ruby/day_time).
