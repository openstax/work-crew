# WorkCrew

[![Build Status](https://travis-ci.org/openstax/work_crew.svg?branch=master)](https://travis-ci.org/openstax/work_crew)

Self-managing and -distributing workers

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'work_crew'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install work_crew
```

## Usage

To run a simple test work crew member, run:

```
rake work_crew:member:test[a7c89b00-72b8-45d8-89b2-2af022cb83b5,1.0,5.0,0.5,2.5,0.0]
```

## Contributing

This gem uses Postgres.  Run

```
createuser --superuser --pwprompt work_crew
```

Use `work_crew` as the password.  Security!




Run `bundle exec rake db:setup` to get your development and test DBs.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
