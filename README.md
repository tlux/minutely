# Minutely

Classes for representing the time of a day by using only hours and minutes.

## Installation

Add this line to your Gemfile:

```ruby
gem 'minutely'
```

Then execute:

```sh
bundle install
```

## Usage

### Time

Create a new time:

```ruby
time1 = Minutely::Time.new(21, 42)
time1.to_s # => "21:42"

time2 = Minutely::Time.new(9, 3)
time2.to_s # => "09:03"
```

Parse time using `DateTime`, `Time`, `String` or `Integer`:

```ruby
Minutely::Time.parse(DateTime.now)
Minutely::Time.parse(Time.now)
Minutely::Time.parse('9:03').to_s # => "09:03"
Minutely::Time.parse(903).to_s # => "09:03"
```

Get the next minute:

```ruby
time = Minutely::Time.parse('9:03')
time.succ.to_s # => "9:04"
```

Compare and sort by times:

```ruby
time1 = Minutely::Time.parse('9:03')
time2 = Minutely::Time.parse('21:42')

time1 == time2 # => false
time1 < time2 # => true
time1 <= time2 # => true
time1 >= time2 # => false
time1 > time2 # => false

[
  Minutely::Time.parse('21:42'),
  Minutely::Time.parse('9:03'),
  Minutely::Time.parse('15:00')
].sort.map(&:to_s) # => ["09:03", "15:00", "21:42"]
```

Native Range support:

```ruby
(Minutely::Time.parse('9:57')..Minutely::Time.parse('10:10'))

```

### Time Range

A special type of time range, that also allows defining ranges spanning over 12
am (0:00).

Create a new time range:

time1 = Minutely::Time.new(9, 3)
```ruby
time2 = Minutely::Time.new(21, 42)

Minutely::TimeRange.new(time1, time2).to_s # => "09:03-21:42"
Minutely::TimeRange.new(time2, time1).to_s # => "21:42-09:03"
```

Parse time range using `String`:

```ruby
Minutely::TimeRange.parse('9:03-21:42')
```

Parse time range using `Hash`:

```ruby
Minutely::TimeRange.parse(from: '9:03', to: '21:42')
```

Check whether time range includes time:

```ruby
range = Minutely::TimeRange.new('9:03', '21:42')

range.include?('10:00') # => true
range.include?('22:00') # => false
```

Convert to Ruby `Range`:

```ruby
Minutely::TimeRange.new('9:03', '21:42').to_r
# => #<Minutely::Time @hour=9, @minute=3>..#<Minutely::Time @hour=21, @minute=42>
```

Convert to Array of `Minutely::Time`s:

```ruby
Minutely::TimeRange.new('23:57', '0:03').to_a.map(&:to_s)
# => ["23:57", "23:58", "23:59", "00:00", "00:01", "00:02", "00:03"]
```

Note this is only possible with ranges not spanning midnight.

## Contributing

Bug reports and pull requests are welcome on [GitHub
Issues](https://github.com/tlux/minutely/issues)
