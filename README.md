# Nippo

## Installation

Add this line to your application's Gemfile:

```
gem 'dl-nippo-helper-xaas'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dl-nippo-helper-xaas

## Usage
You can register a daily task record (so-called `Nippo`) from `nippo-register`. Here is the usage.
```
Usage: register [parameters]

Parameters (All parameters are mandatory for registry):
  -d, --day [day]                  the day to register (DEFAULT: today)
  -m, --month [mon]                the month to register (DEFAULT: current month)
  -y, --year [year]                the year to register (DEFAULT: current year)
  -s, --server hostaddr            host address of Nippo servalueice
  -U, --basic_user uid             userid of BASIC authentication
  -P, --basic_password passwd      password to access Nippo servalueice
  -u, --login_user uid             userid of your-self to login
  -p, --login_password passwd      password which is related to your account
```

To register a `Nippo` on current day, you can do it with following. Context of Nippo would be specified from STDIN.
```
$ nippo-register -s 203.209.xxx.yyy \
                 -U nippo-user \
                 -P password \
                 -u ohyama-hiroyasu\
                 -p XXXXXXX
```
You don't have to input the context of `Nippo` by grace of `xaas` plugin that input appropriate context automatically.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
