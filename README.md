# GemFootprintAnalyzer

A tool for analyzing time and RSS footprint of gems or standard library requires, it's currently in a 'work in progress' state (developed on ruby-2.5.1 / macOS).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gem_footprint_analyzer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gem_footprint_analyzer

## Usage

Analyze a standard library require or a gem. In the gem case, make sure it's included in the Gemfile.

Example usages:

### timeout
```
$ bundle exec analyze_requires timeout
GemFootprintAnalyzer (0.1.1)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name      time   RSS after
------------------------
timeout     3ms   2734KB
```

### net/http
```
GemFootprintAnalyzer (0.1.1)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                             time   RSS after
-----------------------------------------------
net/http                         102ms   8605KB
  net/http/backward                1ms   8605KB
  net/http/proxy_delta             1ms   8510KB
  net/http/responses               2ms   8474KB
  net/http/response                2ms   8160KB
  net/http/requests                1ms   7984KB
  net/http/request                 1ms   7801KB
  net/http/generic_request         2ms   7745KB
  net/http/header                  2ms   7506KB
  net/http/exceptions              1ms   7215KB
  stringio                         0ms   7039KB
  zlib                             1ms   6920KB
  uri                              0ms   6713KB
  net/protocol                    28ms   6610KB
    io/wait                        0ms   6610KB
    timeout                        1ms   6397KB
    socket                        12ms   6168KB
    io/wait                        1ms   6168KB
      socket.so                    2ms   5754KB
```

### activesupport/time
```
GemFootprintAnalyzer (0.1.1)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                                                                   time   RSS after
-------------------------------------------------------------------------------------
active_support/time                                                   1018ms  13511KB
  active_support/core_ext/string/zones                                   5ms  13511KB
    active_support/core_ext/time/zones                                   0ms  13511KB
    active_support/core_ext/string/conversions                           0ms  13456KB
    active_support/core_ext/string/conversions                           5ms  13451KB
      active_support/core_ext/time/calculations                          0ms  13451KB
      date                                                               0ms  13443KB
  active_support/core_ext/numeric/time                                   0ms  13416KB
  active_support/core_ext/integer/time                                  21ms  13413KB
  active_support/core_ext/numeric/time                                  16ms  13413KB
    active_support/core_ext/date/acts_like                               0ms  13413KB
    active_support/core_ext/date/calculations                            0ms  13376KB
    active_support/core_ext/time/acts_like                               0ms  13371KB
      active_support/core_ext/time/calculations                          0ms  13364KB
    active_support/duration                                              0ms  13364KB
    active_support/duration                                              0ms  13351KB
  active_support/core_ext/date_time                                     54ms  13339KB
    active_support/core_ext/date_time/conversions                       17ms  13339KB
      active_support/values/time_zone                                    0ms  13339KB
      active_support/core_ext/date_time/calculations                     0ms  13326KB
      active_support/core_ext/time/conversions                           0ms  13323KB
      active_support/inflector/methods                                   0ms  13322KB
      date                                                               0ms  13317KB
    active_support/core_ext/date_time/compatibility                      5ms  13300KB
      active_support/core_ext/module/redefine_method                     0ms  13300KB
      active_support/core_ext/date_and_time/compatibility                0ms  13287KB
      active_support/core_ext/date_time/calculations                     0ms  13282KB
    active_support/core_ext/date_time/blank                              1ms  13278KB
      date                                                               0ms  13278KB
    active_support/core_ext/date_time/acts_like                          5ms  13264KB
      active_support/core_ext/object/acts_like                           0ms  13264KB
      date                                                               0ms  13252KB
  active_support/core_ext/date                                          42ms  13247KB
    active_support/core_ext/date/zones                                   0ms  13247KB
    active_support/core_ext/date/conversions                            13ms  13241KB
      active_support/core_ext/module/redefine_method                     0ms  13241KB
    active_support/core_ext/date/zones                                   0ms  13231KB
      active_support/inflector/methods                                   0ms  13227KB
      date                                                               0ms  13221KB
    active_support/core_ext/date/calculations                            0ms  13204KB
    active_support/core_ext/date/blank                                   1ms  13201KB
      date                                                               0ms  13201KB
    active_support/core_ext/date/acts_like                               1ms  13197KB
      active_support/core_ext/object/acts_like                           0ms  13197KB
  active_support/core_ext/time                                         817ms  13185KB
    active_support/core_ext/time/zones                                   0ms  13185KB
      active_support/core_ext/time/conversions                           0ms  13172KB
    active_support/core_ext/time/compatibility                           6ms  13170KB
      active_support/core_ext/module/redefine_method                     1ms  13170KB
      active_support/core_ext/date_and_time/compatibility                0ms  13147KB
      active_support/core_ext/time/calculations                        779ms  13142KB
    active_support/core_ext/date/calculations                           30ms  13142KB
      active_support/core_ext/date_and_time/calculations                 0ms  13142KB
    active_support/core_ext/time/zones                                   0ms  13124KB
    active_support/core_ext/date/zones                                   5ms  13119KB
      active_support/core_ext/date_and_time/zones                        0ms  13119KB
      date                                                               0ms  13107KB
      active_support/core_ext/object/acts_like                           0ms  13094KB
    active_support/duration                                              0ms  13092KB
      date                                                               0ms  13088KB
      active_support/core_ext/date_and_time/calculations                 3ms  13058KB
        active_support/core_ext/object/try                               1ms  13058KB
          delegate                                                       0ms  13058KB
    active_support/core_ext/time/zones                                  10ms  12970KB
      active_support/core_ext/date_and_time/zones                        1ms  12970KB
    active_support/core_ext/time/acts_like                               0ms  12900KB
      active_support/time_with_zone                                      0ms  12890KB
      active_support/time_with_zone                                     22ms  12858KB
      active_support/core_ext/date_and_time/compatibility                6ms  12858KB
        active_support/core_ext/module/attribute_accessors               5ms  12858KB
          active_support/core_ext/regexp                                 0ms  12858KB
          active_support/core_ext/array/extract_options                  0ms  12775KB
      active_support/core_ext/object/acts_like                           0ms  12746KB
      active_support/values/time_zone                                    0ms  12739KB
    active_support/duration                                              0ms  12732KB
      active_support/core_ext/time/conversions                         219ms  12490KB
      active_support/values/time_zone                                  215ms  12490KB
        active_support/core_ext/object/blank                             0ms  12490KB
        concurrent/map                                                   0ms  12439KB
        tzinfo                                                         200ms  12437KB
          tzinfo/country_timezone                                        1ms  12437KB
          tzinfo/country                                                 1ms  12369KB
            thread_safe                                                  0ms  12369KB
          tzinfo/zoneinfo_country_info                                   0ms  12275KB
          tzinfo/ruby_country_info                                       1ms  12266KB
          tzinfo/country_info                                            1ms  12214KB
          tzinfo/country_index_definition                                0ms  12196KB
          tzinfo/timezone_proxy                                          1ms  12156KB
          tzinfo/linked_timezone                                         1ms  12126KB
          tzinfo/data_timezone                                           0ms  12083KB
          tzinfo/info_timezone                                           0ms  12067KB
          tzinfo/timezone                                               40ms  12017KB
            thread_safe/cache                                            7ms  12017KB
              thread_safe/mri_cache_backend                              2ms  12017KB
                thread_safe/non_concurrent_cache_backend                 1ms  12017KB
              thread                                                     0ms  11934KB
            thread_safe                                                 11ms  11846KB
              thread_safe/synchronized_delegator                         5ms  11846KB
                monitor                                                  0ms  11846KB
          delegate                                                       0ms  11791KB
              thread_safe/version                                        0ms  11782KB
            set                                                          0ms  11764KB
      date                                                               0ms  11763KB
          tzinfo/timezone_period                                         1ms  11679KB
          tzinfo/zoneinfo_data_source                                    2ms  11641KB
          tzinfo/ruby_data_source                                        1ms  11597KB
          tzinfo/data_source                                             1ms  11569KB
              thread                                                     0ms  11569KB
          tzinfo/zoneinfo_timezone_info                                  1ms  11553KB
          tzinfo/transition_data_timezone_info                           1ms  11498KB
          tzinfo/linked_timezone_info                                    0ms  11456KB
          tzinfo/data_timezone_info                                      0ms  11440KB
          tzinfo/timezone_info                                           0ms  11431KB
          tzinfo/timezone_index_definition                               0ms  11424KB
          tzinfo/timezone_transition_definition                          1ms  11416KB
          tzinfo/timezone_transition                                     1ms  11400KB
          tzinfo/timezone_offset                                         1ms  11388KB
          tzinfo/timezone_definition                                     0ms  11367KB
          tzinfo/time_or_datetime                                        5ms  11353KB
            time                                                         0ms  11353KB
      date                                                               0ms  11344KB
          tzinfo/offset_rationals                                        1ms  11306KB
          tzinfo/ruby_core_support                                       1ms  11263KB
      date                                                               0ms  11263KB
      active_support/inflector/methods                                   0ms  11081KB
    active_support/duration                                            442ms  11070KB
      active_support/deprecation                                         0ms  11070KB
      active_support/core_ext/string/filters                             1ms  11042KB
      active_support/core_ext/object/acts_like                           0ms  11034KB
      active_support/core_ext/module/delegation                          0ms  11030KB
      active_support/core_ext/array/conversions                        419ms  11026KB
        active_support/core_ext/object/to_query                          0ms  11026KB
        active_support/core_ext/object/to_param                          1ms  11013KB
        active_support/core_ext/object/to_query                          1ms  11013KB
          cgi                                                            0ms  11013KB
        active_support/core_ext/string/inflections                       0ms  10974KB
        active_support/core_ext/hash/keys                                1ms  10967KB
        active_support/xml_mini                                        385ms  10915KB
          active_support/xml_mini/rexml                                 20ms  10915KB
            stringio                                                     0ms  10915KB
        active_support/core_ext/object/blank                             5ms  10910KB
        concurrent/map                                                   0ms  10910KB
          active_support/core_ext/regexp                                 0ms  10890KB
            active_support/core_ext/kernel/reporting                     1ms  10861KB
      active_support/core_ext/date_time/calculations                     1ms  10816KB
      date                                                               0ms  10816KB
        active_support/core_ext/string/inflections                     316ms  10741KB
          active_support/inflector/transliterate                        10ms  10741KB
            active_support/i18n                                          0ms  10741KB
            active_support/core_ext/string/multibyte                     1ms  10721KB
              active_support/multibyte                                   0ms  10721KB
      active_support/inflector/methods                                 298ms  10675KB
          active_support/core_ext/regexp                                 0ms  10675KB
        active_support/inflections                                     283ms  10660KB
          active_support/inflector/inflections                         281ms  10660KB
      active_support/deprecation                                        96ms  10660KB
        active_support/core_ext/module/deprecation                       1ms  10660KB
        active_support/deprecation/proxy_wrappers                        1ms  10406KB
          active_support/core_ext/regexp                                 0ms  10406KB
        active_support/deprecation/method_wrappers                       6ms  10334KB
          active_support/core_ext/array/extract_options                  1ms  10334KB
          active_support/core_ext/module/aliasing                        1ms  10312KB
        active_support/deprecation/constant_accessor                     1ms  10298KB
        active_support/deprecation/reporting                             1ms  10286KB
          rbconfig                                                       0ms  10286KB
        active_support/deprecation/behaviors                            26ms  10247KB
          active_support/notifications                                  25ms  10247KB
            active_support/per_thread_registry                           1ms  10247KB
      active_support/core_ext/module/delegation                          0ms  10247KB
            active_support/notifications/fanout                          6ms  10200KB
        concurrent/map                                                   0ms  10200KB
              mutex_m                                                    1ms  10186KB
            active_support/notifications/instrumenter                    2ms  10164KB
              securerandom                                               1ms  10164KB
        active_support/deprecation/instance_delegator                    5ms  10052KB
      active_support/core_ext/module/delegation                          0ms  10052KB
          active_support/core_ext/kernel/singleton_class                 1ms  10033KB
        singleton                                                        1ms  10026KB
            active_support/i18n                                         48ms   9995KB
  i18n/config                                                            1ms   9995KB
            set                                                          0ms   9995KB
              active_support/lazy_load_hooks                             1ms   9914KB
              i18n                                                      20ms   9886KB
                i18n/interpolate/ruby                                    1ms   9886KB
                i18n/exceptions                                          1ms   9765KB
          cgi                                                            0ms   9765KB
                i18n/version                                             0ms   9620KB
        concurrent/map                                                   0ms   9598KB
              active_support/core_ext/hash/slice                         1ms   9491KB
              active_support/core_ext/hash/except                        0ms   9425KB
              active_support/core_ext/hash/deep_merge                    1ms   9403KB
          active_support/core_ext/regexp                                 0ms   9326KB
            active_support/core_ext/array/prepend_and_append             0ms   9308KB
        concurrent/map                                                 102ms   9282KB
          concurrent/collection/map/mri_map_backend                      6ms   9282KB
            concurrent/collection/map/non_concurrent_map_backend         1ms   9282KB
              concurrent/constants                                       0ms   9282KB
              thread                                                     0ms   9021KB
          concurrent/synchronization                                    79ms   8911KB
            concurrent/synchronization/lock                              1ms   8911KB
            concurrent/synchronization/condition                         1ms   8835KB
            concurrent/synchronization/lockable_object                   1ms   8729KB
            concurrent/synchronization/truffle_lockable_object           0ms   8659KB
            concurrent/synchronization/rbx_lockable_object               1ms   8619KB
            concurrent/synchronization/jruby_lockable_object             0ms   8567KB
            concurrent/synchronization/mri_lockable_object               1ms   8532KB
            concurrent/synchronization/abstract_lockable_object          1ms   8468KB
            concurrent/synchronization/volatile                          0ms   8412KB
            concurrent/synchronization/object                            1ms   8359KB
            concurrent/synchronization/truffle_object                    1ms   8238KB
            concurrent/synchronization/rbx_object                        1ms   8188KB
            concurrent/synchronization/jruby_object                      1ms   8124KB
            concurrent/synchronization/mri_object                        1ms   8076KB
            concurrent/utility/native_extension_loader                   1ms   8000KB
              concurrent/utility/engine                                  0ms   8000KB
            concurrent/synchronization/abstract_object                   0ms   7898KB
              concurrent/utility/engine                                  1ms   7836KB
              concurrent/constants                                       0ms   7749KB
              thread                                                     0ms   7675KB
      active_support/core_ext/module/delegation                          7ms   7019KB
          active_support/core_ext/regexp                                 0ms   7019KB
            set                                                          0ms   6888KB
          bigdecimal                                                     1ms   6718KB
          base64                                                         1ms   6492KB
            time                                                         0ms   6321KB
    active_support/core_ext/time/acts_like                               1ms   5086KB
      active_support/core_ext/object/acts_like                           0ms   5086KB
            time                                                         4ms   4698KB
      date                                                               0ms   4698KB
      date                                                               4ms   3610KB
        date_core                                                        2ms   3610KB
```

### archfiend
```
GemFootprintAnalyzer (0.1.1)

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name                                        time   RSS after
----------------------------------------------------------
archfiend                                    62ms   6658KB
  archfiend/subprocess_loop                   1ms   6658KB
  archfiend/thread_loop                       1ms   6345KB
  archfiend/shared_loop/runnable              1ms   6150KB
  archfiend/logging/multi_logger              1ms   6012KB
  archfiend/logging/default_formatter         1ms   5816KB
  archfiend/logging/base_formatter            1ms   5640KB
  archfiend/logging                           5ms   5420KB
    logger                                    4ms   5420KB
      monitor                                 0ms   5420KB
  archfiend/application                       3ms   3942KB
  archfiend/version                           1ms   2395KB
  forwardable                                 0ms   1858KB
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gem_footprint_analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GemFootprintAnalyzer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gem_footprint_analyzer/blob/master/CODE_OF_CONDUCT.md).
