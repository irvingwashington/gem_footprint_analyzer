# GemFootprintAnalyzer
[![Gem Version](https://badge.fury.io/rb/gem_footprint_analyzer.svg)](https://badge.fury.io/rb/gem_footprint_analyzer)
[![Build Status](https://api.travis-ci.org/irvingwashington/gem_footprint_analyzer.svg?branch=master)](https://travis-ci.org/irvingwashington/gem_footprint_analyzer)

A tool for analyzing time and RSS footprint of gems or standard library requires.
Requires Ruby >= 2.2.0, works on Linux and MacOS.

## Usage

You can use this gem with or without Bundler. Using Bundler is more convenient and does not have any
impact on results, however you have to have `gem_footprint_analyzer` present in your Gemfile
(use the development section).

Banner
```bash
GemFootprintAnalyzer (0.1.6)
Usage: bundle exec analyze_requires library_to_analyze [require]
    -f, --formatter FORMATTER        Format output using selected formatter (json tree)
    -n, --runs-num NUMBER            Number of runs
    -r, --rubygems                   Require rubygems before the actual analyze
    -g, --gemfile                    Analyze current Gemfile
    -d, --debug                      Show debug information
    -h, --help                       Show this message
```

1) with Bundler
```bash
# Standard library
$ bundle exec analyze_requires net/http

# Gem with non-standard require
$ bundle exec analyze_requires activerecord active_record
```

2) without Bundler
```bash
# Standard library
$ analyze_requires net/http

# Analyzing gems without Bundler will require you provide all dependencies paths in the RUBYLIB env var
$ RUBYLIB=/Users/irving/.gem/ruby/2.5.3/gems/activerecord-5.2.1/lib:/Users/irving/.gem/ruby/2.5.3/gems/activesupport-5.2.1/lib/:/Users/irving/.gem/ruby/2.5.3/gems/concurrent-ruby-1.0.5/lib:/Users/irving/.gem/ruby/2.5.3/gems/i18n-1.1.1/lib:/Users/irving/.gem/ruby/2.5.3/gems/activemodel-5.2.1/lib:/Users/irving/.gem/ruby/2.5.3/gems/arel-9.0.0/lib:/Users/irving/.gem/ruby/2.5.3/gems/tzinfo-1.2.5/lib:/Users/irving/.gem/ruby/2.5.3/gems/thread_safe-0.3.6/lib analyze_requries activerecord active_record
```

## Analyzing Gemfile

GemFootprintAnalyzer can be used to analyze the whole Gemfile of a given project.
This way, it is cleary visible which gems take most time or consume most RSS on application start.
You can also see what kind of impact does adding a new dependency have on the the project footprint.
As processing of all gems might take a lot of time, it is advisable to set the number of runs to 1.

```bash
# Analyze the entire Gemfile, with a single run
irving:~/Workspace/motoperf (master)$ bundle exec analyze_requires -gn1
GemFootprintAnalyzer (0.1.6)

Analyze results (average measured from 1 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                          time   RSS after
--------------------------------------------
newrelic_rpm                 1540ms  38540KB
draper                        242ms  31544KB
activemodel-serializers-xml    46ms  29248KB
slim                          261ms  29088KB
dalli                         107ms  26036KB
bcrypt                         31ms  25872KB
will_paginate                  45ms  25848KB
jbuilder                      190ms  25844KB
jquery-rails                   17ms  25808KB
uglifier                      135ms  25808KB
sass-rails                   3379ms  25676KB
pg                            108ms  13260KB
rails                        3516ms  12612KB

Total runtime 10.0740s
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gem_footprint_analyzer', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gem_footprint_analyzer

## Example analyses (Ruby 2.5.3):

### timeout
```
$ analyze_requires timeout
GemFootprintAnalyzer (0.1.5)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name      time   RSS after
------------------------
timeout     1ms    226KB

Total runtime 0.3430s
```

### net/http
```
$ analyze_requires net/http
GemFootprintAnalyzer (0.1.5)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                                 time   RSS after
---------------------------------------------------
net/http                             182ms   2897KB
  net/http/backward                    1ms   2897KB
  net/http/proxy_delta                 1ms   2886KB
  net/http/responses                   2ms   2885KB
  net/http/response                    2ms   2782KB
  net/http/requests                    1ms   2706KB
  net/http/request                     1ms   2676KB
  net/http/generic_request             3ms   2670KB
  net/http/header                      2ms   2575KB
  net/http/exceptions                  1ms   2416KB
  stringio                             1ms   2397KB
  zlib                                 1ms   2355KB
  uri                                 78ms   2296KB
    uri/mailto                         2ms   2296KB
      uri/generic                      0ms   2296KB
    uri/ldaps                          1ms   2078KB
      uri/ldap                         0ms   2078KB
      uri/ldap                         1ms   2065KB
      uri/generic                      0ms   2065KB
    uri/https                          1ms   2016KB
      uri/http                         0ms   2016KB
      uri/http                         1ms   2012KB
      uri/generic                      0ms   2012KB
    uri/ftp                            1ms   2004KB
      uri/generic                      0ms   2004KB
      uri/generic                      4ms   1976KB
        uri/common                     0ms   1976KB
        uri/common                    14ms   1698KB
          uri/rfc3986_parser           2ms   1693KB
          uri/rfc2396_parser           2ms   1558KB
  net/protocol                        26ms   1190KB
    io/wait                            1ms   1190KB
    timeout                            1ms   1165KB
    socket                            10ms   1119KB
    io/wait                            1ms   1119KB
      socket.so                        1ms   1089KB

Total runtime 2.1813s
```

### activesupport/time
```
$ bundle exec analyze_requires active_support active_support/time
GemFootprintAnalyzer (0.1.5)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                                                                   time   RSS after
-------------------------------------------------------------------------------------
active_support/time                                                   1082ms   5084KB
  active_support/core_ext/string/zones                                   5ms   5084KB
    active_support/core_ext/time/zones                                   0ms   5084KB
    active_support/core_ext/string/conversions                           0ms   5082KB
    active_support/core_ext/string/conversions                           5ms   5080KB
      active_support/core_ext/time/calculations                          0ms   5080KB
      date                                                               0ms   5078KB
  active_support/core_ext/numeric/time                                   0ms   5074KB
  active_support/core_ext/integer/time                                  23ms   5074KB
  active_support/core_ext/numeric/time                                  18ms   5074KB
    active_support/core_ext/date/acts_like                               0ms   5074KB
    active_support/core_ext/date/calculations                            0ms   5066KB
    active_support/core_ext/time/acts_like                               0ms   5066KB
      active_support/core_ext/time/calculations                          0ms   5066KB
    active_support/duration                                              0ms   5064KB
    active_support/duration                                              0ms   5060KB
  active_support/core_ext/date_time                                     56ms   5058KB
    active_support/core_ext/date_time/conversions                       18ms   5058KB
      active_support/values/time_zone                                    0ms   5058KB
      active_support/core_ext/date_time/calculations                     0ms   5047KB
      active_support/core_ext/time/conversions                           0ms   5046KB
      active_support/inflector/methods                                   0ms   5043KB
      date                                                               0ms   5043KB
    active_support/core_ext/date_time/compatibility                      5ms   5040KB
      active_support/core_ext/module/redefine_method                     0ms   5040KB
      active_support/core_ext/date_and_time/compatibility                0ms   5036KB
      active_support/core_ext/date_time/calculations                     0ms   5033KB
    active_support/core_ext/date_time/blank                              1ms   5033KB
      date                                                               0ms   5033KB
    active_support/core_ext/date_time/acts_like                          5ms   5028KB
      active_support/core_ext/object/acts_like                           0ms   5028KB
      date                                                               0ms   5025KB
  active_support/core_ext/date                                          43ms   5016KB
    active_support/core_ext/date/zones                                   0ms   5016KB
    active_support/core_ext/date/conversions                            13ms   5011KB
      active_support/core_ext/module/redefine_method                     0ms   5011KB
    active_support/core_ext/date/zones                                   0ms   5002KB
      active_support/inflector/methods                                   0ms   5000KB
      date                                                               0ms   4997KB
    active_support/core_ext/date/calculations                            0ms   4989KB
    active_support/core_ext/date/blank                                   1ms   4987KB
      date                                                               0ms   4987KB
    active_support/core_ext/date/acts_like                               1ms   4975KB
      active_support/core_ext/object/acts_like                           0ms   4975KB
  active_support/core_ext/time                                         878ms   4964KB
    active_support/core_ext/time/zones                                   0ms   4964KB
      active_support/core_ext/time/conversions                           0ms   4959KB
    active_support/core_ext/time/compatibility                           6ms   4958KB
      active_support/core_ext/module/redefine_method                     1ms   4958KB
      active_support/core_ext/date_and_time/compatibility                0ms   4939KB
      active_support/core_ext/time/calculations                        839ms   4931KB
    active_support/core_ext/date/calculations                           31ms   4931KB
      active_support/core_ext/date_and_time/calculations                 0ms   4931KB
    active_support/core_ext/time/zones                                   0ms   4919KB
    active_support/core_ext/date/zones                                   5ms   4916KB
      active_support/core_ext/date_and_time/zones                        0ms   4916KB
      date                                                               0ms   4910KB
      active_support/core_ext/object/acts_like                           0ms   4904KB
    active_support/duration                                              0ms   4904KB
      date                                                               0ms   4904KB
      active_support/core_ext/date_and_time/calculations                 3ms   4879KB
        active_support/core_ext/object/try                               1ms   4879KB
          delegate                                                       0ms   4879KB
    active_support/core_ext/time/zones                                  10ms   4808KB
      active_support/core_ext/date_and_time/zones                        1ms   4808KB
    active_support/core_ext/time/acts_like                               0ms   4798KB
      active_support/time_with_zone                                      0ms   4796KB
      active_support/time_with_zone                                     22ms   4788KB
      active_support/core_ext/date_and_time/compatibility                6ms   4788KB
        active_support/core_ext/module/attribute_accessors               5ms   4788KB
          active_support/core_ext/regexp                                 0ms   4788KB
          active_support/core_ext/array/extract_options                  0ms   4762KB
      active_support/core_ext/object/acts_like                           0ms   4747KB
      active_support/values/time_zone                                    0ms   4747KB
    active_support/duration                                              0ms   4746KB
      active_support/core_ext/time/conversions                         228ms   4628KB
      active_support/values/time_zone                                  223ms   4628KB
        active_support/core_ext/object/blank                             0ms   4628KB
        concurrent/map                                                   0ms   4599KB
        tzinfo                                                         208ms   4594KB
          tzinfo/country_timezone                                        1ms   4594KB
          tzinfo/country                                                 1ms   4581KB
            thread_safe                                                  0ms   4581KB
          tzinfo/zoneinfo_country_info                                   1ms   4566KB
          tzinfo/ruby_country_info                                       1ms   4561KB
          tzinfo/country_info                                            1ms   4560KB
          tzinfo/country_index_definition                                1ms   4554KB
          tzinfo/timezone_proxy                                          1ms   4552KB
          tzinfo/linked_timezone                                         1ms   4547KB
          tzinfo/data_timezone                                           1ms   4540KB
          tzinfo/info_timezone                                           1ms   4538KB
          tzinfo/timezone                                               43ms   4532KB
            thread_safe/cache                                            8ms   4532KB
              thread_safe/mri_cache_backend                              2ms   4532KB
                thread_safe/non_concurrent_cache_backend                 1ms   4532KB
              thread                                                     0ms   4460KB
            thread_safe                                                 13ms   4418KB
              thread_safe/synchronized_delegator                         8ms   4418KB
                monitor                                                  1ms   4418KB
          delegate                                                       2ms   4384KB
              thread_safe/version                                        0ms   4353KB
            set                                                          0ms   4352KB
      date                                                               0ms   4351KB
          tzinfo/timezone_period                                         1ms   4292KB
          tzinfo/zoneinfo_data_source                                    2ms   4269KB
          tzinfo/ruby_data_source                                        1ms   4208KB
          tzinfo/data_source                                             1ms   4196KB
              thread                                                     0ms   4196KB
          tzinfo/zoneinfo_timezone_info                                  2ms   4175KB
          tzinfo/transition_data_timezone_info                           1ms   4095KB
          tzinfo/linked_timezone_info                                    1ms   4052KB
          tzinfo/data_timezone_info                                      1ms   4037KB
          tzinfo/timezone_info                                           1ms   4026KB
          tzinfo/timezone_index_definition                               1ms   4020KB
          tzinfo/timezone_transition_definition                          1ms   4012KB
          tzinfo/timezone_transition                                     1ms   4002KB
          tzinfo/timezone_offset                                         1ms   3991KB
          tzinfo/timezone_definition                                     1ms   3977KB
          tzinfo/time_or_datetime                                        5ms   3974KB
            time                                                         0ms   3974KB
      date                                                               0ms   3970KB
          tzinfo/offset_rationals                                        1ms   3953KB
          tzinfo/ruby_core_support                                       1ms   3940KB
      date                                                               0ms   3940KB
      active_support/inflector/methods                                   0ms   3836KB
    active_support/duration                                            491ms   3833KB
      active_support/deprecation                                         0ms   3833KB
      active_support/core_ext/string/filters                             1ms   3779KB
      active_support/core_ext/object/acts_like                           0ms   3775KB
      active_support/core_ext/module/delegation                          0ms   3774KB
      active_support/core_ext/array/conversions                        468ms   3772KB
        active_support/core_ext/object/to_query                          0ms   3772KB
        active_support/core_ext/object/to_param                          2ms   3768KB
        active_support/core_ext/object/to_query                          1ms   3768KB
          cgi                                                            0ms   3768KB
        active_support/core_ext/string/inflections                       0ms   3765KB
        active_support/core_ext/hash/keys                                1ms   3765KB
        active_support/xml_mini                                        434ms   3756KB
          active_support/xml_mini/rexml                                 20ms   3756KB
            stringio                                                     1ms   3756KB
        active_support/core_ext/object/blank                             5ms   3734KB
        concurrent/map                                                   0ms   3734KB
          active_support/core_ext/regexp                                 0ms   3730KB
            active_support/core_ext/kernel/reporting                     1ms   3718KB
      active_support/core_ext/date_time/calculations                     2ms   3711KB
      date                                                               0ms   3711KB
        active_support/core_ext/string/inflections                     361ms   3669KB
          active_support/inflector/transliterate                        10ms   3669KB
            active_support/i18n                                          0ms   3669KB
            active_support/core_ext/string/multibyte                     1ms   3653KB
              active_support/multibyte                                   0ms   3653KB
      active_support/inflector/methods                                 342ms   3638KB
          active_support/core_ext/regexp                                 0ms   3638KB
        active_support/inflections                                     326ms   3618KB
          active_support/inflector/inflections                         324ms   3618KB
      active_support/deprecation                                       104ms   3618KB
        active_support/core_ext/module/deprecation                       1ms   3618KB
        active_support/deprecation/proxy_wrappers                        1ms   3390KB
          active_support/core_ext/regexp                                 0ms   3390KB
        active_support/deprecation/method_wrappers                       6ms   3376KB
          active_support/core_ext/array/extract_options                  1ms   3376KB
          active_support/core_ext/module/aliasing                        1ms   3374KB
        active_support/deprecation/constant_accessor                     1ms   3365KB
        active_support/deprecation/reporting                             4ms   3346KB
          rbconfig                                                       3ms   3346KB
        active_support/deprecation/behaviors                            27ms   3106KB
          active_support/notifications                                  26ms   3106KB
            active_support/per_thread_registry                           1ms   3106KB
      active_support/core_ext/module/delegation                          0ms   3106KB
            active_support/notifications/fanout                          6ms   3056KB
        concurrent/map                                                   0ms   3056KB
              mutex_m                                                    1ms   3039KB
            active_support/notifications/instrumenter                    2ms   2985KB
              securerandom                                               1ms   2985KB
        active_support/deprecation/instance_delegator                    6ms   2867KB
      active_support/core_ext/module/delegation                          0ms   2867KB
          active_support/core_ext/kernel/singleton_class                 1ms   2840KB
        singleton                                                        1ms   2828KB
            active_support/i18n                                         77ms   2786KB
  i18n/config                                                            1ms   2786KB
            set                                                          0ms   2786KB
              active_support/lazy_load_hooks                             1ms   2740KB
              i18n                                                      48ms   2718KB
                i18n/interpolate/ruby                                    1ms   2718KB
                i18n/exceptions                                         25ms   2543KB
          cgi                                                           24ms   2543KB
            cgi/util                                                     0ms   2543KB
            cgi/cookie                                                   4ms   2528KB
            cgi/util                                                     3ms   2528KB
              cgi/escape                                                 1ms   2528KB
            cgi/core                                                     3ms   2452KB
                i18n/version                                             0ms   2228KB
        concurrent/map                                                   0ms   2220KB
              active_support/core_ext/hash/slice                         1ms   2181KB
              active_support/core_ext/hash/except                        1ms   2164KB
              active_support/core_ext/hash/deep_merge                    1ms   2154KB
          active_support/core_ext/regexp                                 0ms   2142KB
            active_support/core_ext/array/prepend_and_append             1ms   2137KB
        concurrent/map                                                 107ms   2124KB
          concurrent/collection/map/mri_map_backend                      6ms   2124KB
            concurrent/collection/map/non_concurrent_map_backend         1ms   2124KB
              concurrent/constants                                       0ms   2124KB
              thread                                                     0ms   2070KB
          concurrent/synchronization                                    82ms   2055KB
            concurrent/synchronization/lock                              1ms   2055KB
            concurrent/synchronization/condition                         1ms   2042KB
            concurrent/synchronization/lockable_object                   1ms   2021KB
            concurrent/synchronization/truffle_lockable_object           1ms   1994KB
            concurrent/synchronization/rbx_lockable_object               1ms   1986KB
            concurrent/synchronization/jruby_lockable_object             1ms   1966KB
            concurrent/synchronization/mri_lockable_object               1ms   1949KB
            concurrent/synchronization/abstract_lockable_object          1ms   1914KB
            concurrent/synchronization/volatile                          1ms   1891KB
            concurrent/synchronization/object                            1ms   1866KB
            concurrent/synchronization/truffle_object                    1ms   1815KB
            concurrent/synchronization/rbx_object                        1ms   1779KB
            concurrent/synchronization/jruby_object                      1ms   1742KB
            concurrent/synchronization/mri_object                        1ms   1707KB
            concurrent/utility/native_extension_loader                   1ms   1660KB
              concurrent/utility/engine                                  0ms   1660KB
            concurrent/synchronization/abstract_object                   1ms   1581KB
              concurrent/utility/engine                                  1ms   1562KB
              concurrent/constants                                       0ms   1506KB
              thread                                                     0ms   1490KB
      active_support/core_ext/module/delegation                          8ms   1325KB
          active_support/core_ext/regexp                                 1ms   1325KB
            set                                                          2ms   1304KB
          bigdecimal                                                     1ms   1159KB
          base64                                                         1ms   1108KB
            time                                                         0ms   1098KB
    active_support/core_ext/time/acts_like                               1ms    655KB
      active_support/core_ext/object/acts_like                           0ms    655KB
            time                                                         3ms    610KB
      date                                                               0ms    610KB
      date                                                               2ms    367KB
        date_core                                                        1ms    367KB

Total runtime 11.2834s
```

### archfiend
```
$ bundle exec analyze_requires archfiend
GemFootprintAnalyzer (0.1.5)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                                        time   RSS after
----------------------------------------------------------
archfiend                                    64ms    888KB
  archfiend/daemon                            1ms    888KB
  archfiend/subprocess_loop                   1ms    855KB
  archfiend/thread_loop                       1ms    835KB
  archfiend/shared_loop/runnable              0ms    820KB
  archfiend/logging/multi_logger              1ms    817KB
  archfiend/logging/default_formatter         0ms    804KB
  archfiend/logging/base_formatter            1ms    800KB
  archfiend/logging                           5ms    779KB
    logger                                    4ms    779KB
      monitor                                 1ms    779KB
  archfiend/application                       1ms    490KB
  archfiend/version                           0ms    327KB
  forwardable                                 2ms    309KB
    forwardable/impl                          1ms    309KB

Total runtime 0.9878s
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/irvingwashington/gem_footprint_analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GemFootprintAnalyzer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gem_footprint_analyzer/blob/master/CODE_OF_CONDUCT.md).
