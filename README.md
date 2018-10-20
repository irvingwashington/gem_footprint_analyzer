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
  name       time     RSS after
-----------------------------
timeout      0.0032s  2140KB
```

### net/http
```
$ bundle exec analyze_requires net/http
  name         time     RSS after
-------------------------------
  socket.so    0.0019s  4920KB
  io/wait      0.0009s  5296KB
  socket       0.0108s  5296KB
  timeout      0.0014s  5736KB
  zlib         0.0012s  5924KB
-------------------------------
net/http       0.0476s  6712KB
```

### activesupport/all
```
$ bundle exec analyze_requires activesupport active_support/all
  name                                                               time     RSS after
--------------------------------------------------------------------------------------
  securerandom                                                       0.0022s  2728KB
  concurrent/constants                                               0.0005s  4168KB
  concurrent/utility/engine                                          0.0006s  4268KB
  concurrent/synchronization/abstract_object                         0.0006s  4360KB
  concurrent/utility/native_extension_loader                         0.0015s  5008KB
  concurrent/synchronization/mri_object                              0.0006s  5132KB
  concurrent/synchronization/jruby_object                            0.0006s  5172KB
  concurrent/synchronization/rbx_object                              0.0006s  5212KB
  concurrent/synchronization/truffle_object                          0.0007s  5312KB
  concurrent/synchronization/object                                  0.0010s  5416KB
  concurrent/synchronization/volatile                                0.0006s  5536KB
  concurrent/synchronization/abstract_lockable_object                0.0007s  5656KB
  concurrent/synchronization/mri_lockable_object                     0.0008s  5776KB
  concurrent/synchronization/jruby_lockable_object                   0.0005s  5840KB
  concurrent/synchronization/rbx_lockable_object                     0.0007s  5864KB
  concurrent/synchronization/truffle_lockable_object                 0.0004s  5884KB
  concurrent/synchronization/lockable_object                         0.0005s  5936KB
  concurrent/synchronization/condition                               0.0007s  5984KB
  concurrent/synchronization/lock                                    0.0005s  6012KB
  concurrent/synchronization                                         0.0745s  6012KB
  concurrent/collection/map/non_concurrent_map_backend               0.0010s  6144KB
  concurrent/collection/map/mri_map_backend                          0.0018s  6144KB
  concurrent/map                                                     0.0894s  6144KB
  active_support/core_ext/array/prepend_and_append                   0.0004s  6156KB
  active_support/core_ext/regexp                                     0.0004s  6180KB
  active_support/core_ext/hash/deep_merge                            0.0005s  6280KB
  active_support/core_ext/hash/except                                0.0005s  6304KB
  active_support/core_ext/hash/slice                                 0.0006s  6424KB
  i18n/version                                                       0.0003s  6512KB
  i18n/exceptions                                                    0.0012s  6688KB
  i18n/interpolate/ruby                                              0.0006s  6776KB
  i18n                                                               0.0114s  6776KB
  active_support/lazy_load_hooks                                     0.0006s  6812KB
  i18n/config                                                        0.0009s  6932KB
  active_support/i18n                                                0.0374s  6932KB
  singleton                                                          0.0006s  6992KB
  active_support/core_ext/kernel/singleton_class                     0.0005s  7048KB
  active_support/core_ext/module/delegation                          0.0020s  7208KB
  active_support/deprecation/instance_delegator                      0.0068s  7208KB
  active_support/notifications/instrumenter                          0.0008s  7332KB
  mutex_m                                                            0.0005s  7428KB
  active_support/notifications/fanout                                0.0053s  7460KB
  active_support/per_thread_registry                                 0.0005s  7480KB
  active_support/notifications                                       0.0146s  7480KB
  active_support/deprecation/behaviors                               0.0153s  7480KB
  active_support/deprecation/reporting                               0.0010s  7560KB
  active_support/deprecation/constant_accessor                       0.0007s  7688KB
  active_support/core_ext/module/aliasing                            0.0005s  7732KB
  active_support/core_ext/array/extract_options                      0.0004s  7748KB
  active_support/deprecation/method_wrappers                         0.0052s  7748KB
  active_support/deprecation/proxy_wrappers                          0.0010s  7832KB
  active_support/core_ext/module/deprecation                         0.0005s  8276KB
  active_support/deprecation                                         0.0723s  8276KB
  active_support/inflector/inflections                               0.2265s  8276KB
  active_support/inflections                                         0.2285s  8276KB
  active_support/inflector/methods                                   0.2426s  8284KB
  active_support/dependencies/autoload                               0.2438s  8284KB
  active_support/version                                             0.0006s  8308KB
  active_support/concern                                             0.0007s  8620KB
  active_support/core_ext/module/attribute_accessors                 0.0011s  8688KB
  concurrent/version                                                 0.0003s  8728KB
  concurrent/errors                                                  0.0006s  8768KB
  timeout                                                            0.0009s  9052KB
  concurrent/atomic/event                                            0.0008s  9080KB
  concurrent/concern/dereferenceable                                 0.0006s  9116KB
  concurrent/concern/obligation                                      0.0107s  9116KB
  logger                                                             0.0024s  9632KB
  concurrent/concern/logging                                         0.0029s  9632KB
  concurrent/executor/executor_service                               0.0035s  9632KB
  concurrent/utility/at_exit                                         0.0010s  9640KB
  concurrent/executor/abstract_executor_service                      0.0173s  9640KB
  concurrent/executor/serial_executor_service                        0.0005s  9640KB
  concurrent/executor/immediate_executor                             0.0263s  9640KB
  concurrent/delay                                                   0.0523s  9648KB
  concurrent/atomic_reference/concurrent_update_error                0.0004s  9656KB
  concurrent/atomic_reference/direct_update                          0.0005s  9672KB
  concurrent/atomic_reference/numeric_cas_wrapper                    0.0005s  9680KB
  concurrent/atomic_reference/mutex_atomic                           0.0054s  9680KB
  concurrent/atomic_reference/ruby                                   0.0004s  9688KB
  concurrent/atomic/atomic_reference                                 0.0179s  9688KB
  concurrent/utility/processor_counter                               0.0012s  9728KB
  concurrent/configuration                                           0.0837s  9728KB
  concurrent/atomic/mutex_atomic_boolean                             0.0006s  9732KB
  concurrent/atomic/atomic_boolean                                   0.0049s  9732KB
  concurrent/utility/native_integer                                  0.0006s  9800KB
  concurrent/atomic/mutex_atomic_fixnum                              0.0013s  9800KB
  concurrent/atomic/atomic_fixnum                                    0.0093s  9800KB
  concurrent/atomic/cyclic_barrier                                   0.0010s  9816KB
  concurrent/atomic/mutex_count_down_latch                           0.0006s  9820KB
  concurrent/atomic/java_count_down_latch                            0.0005s  9832KB
  concurrent/atomic/count_down_latch                                 0.0091s  9832KB
  concurrent/atomic/read_write_lock                                  0.0014s  9876KB
  concurrent/atomic/abstract_thread_local_var                        0.0006s  9920KB
  concurrent/atomic/ruby_thread_local_var                            0.0015s  9920KB
  concurrent/atomic/java_thread_local_var                            0.0008s  9948KB
  concurrent/atomic/thread_local_var                                 0.0145s  9956KB
  concurrent/atomic/reentrant_read_write_lock                        0.0162s  9956KB
  concurrent/atomic/mutex_semaphore                                  0.0012s 10164KB
  concurrent/atomic/semaphore                                        0.0057s 10164KB
  concurrent/atomics                                                 0.0782s 10164KB
  concurrent/executor/ruby_executor_service                          0.0008s 10192KB
  concurrent/utility/monotonic_time                                  0.0006s 10208KB
  concurrent/executor/ruby_thread_pool_executor                      0.0070s 10208KB
  concurrent/executor/thread_pool_executor                           0.0076s 10208KB
  concurrent/executor/cached_thread_pool                             0.0083s 10208KB
  concurrent/executor/fixed_thread_pool                              0.0007s 10212KB
  concurrent/executor/simple_executor_service                        0.0008s 10236KB
  concurrent/executor/indirect_immediate_executor                    0.0015s 10236KB
  concurrent/executor/java_executor_service                          0.0009s 10260KB
  concurrent/executor/java_single_thread_executor                    0.0005s 10268KB
  concurrent/executor/java_thread_pool_executor                      0.0007s 10292KB
  concurrent/executor/ruby_single_thread_executor                    0.0005s 10292KB
  concurrent/executor/safe_task_executor                             0.0006s 10292KB
  concurrent/executor/serialized_execution                           0.0011s 10368KB
  concurrent/executor/serialized_execution_delegator                 0.0008s 10376KB
  concurrent/executor/single_thread_executor                         0.0006s 10380KB
  concurrent/collection/copy_on_write_observer_set                   0.0008s 10460KB
  concurrent/collection/copy_on_notify_observer_set                  0.0008s 10508KB
  concurrent/concern/observable                                      0.0053s 10508KB
  concurrent/ivar                                                    0.0148s 10512KB
  concurrent/options                                                 0.0006s 10512KB
  concurrent/scheduled_task                                          0.0203s 10512KB
  concurrent/collection/java_non_concurrent_priority_queue           0.0006s 10564KB
  concurrent/collection/ruby_non_concurrent_priority_queue           0.0008s 10564KB
  concurrent/collection/non_concurrent_priority_queue                0.0096s 10640KB
  concurrent/executor/timer_set                                      0.0420s 10644KB
  concurrent/executors                                               0.1153s 10644KB
  concurrent/agent                                                   0.0023s 10748KB
  concurrent/atom                                                    0.0012s 10768KB
  concurrent/thread_safe/util                                        0.0004s 10772KB
  concurrent/array                                                   0.0019s 10772KB
  concurrent/hash                                                    0.0007s 10776KB
  concurrent/tuple                                                   0.0007s 10780KB
  concurrent/async                                                   0.0012s 10780KB
  concurrent/future                                                  0.0011s 10784KB
  concurrent/dataflow                                                0.0057s 10784KB
  concurrent/maybe                                                   0.0007s 10796KB
  concurrent/exchanger                                               0.0063s 10796KB
  concurrent/synchronization/abstract_struct                         0.0009s 10848KB
  concurrent/immutable_struct                                        0.0054s 10852KB
  concurrent/mutable_struct                                          0.0011s 10880KB
  concurrent/mvar                                                    0.0011s 10884KB
  concurrent/promise                                                 0.0021s 10888KB
  concurrent/settable_struct                                         0.0012s 10896KB
  concurrent/timer_task                                              0.0016s 10940KB
  concurrent/tvar                                                    0.0013s 10984KB
  concurrent/thread_safe/synchronized_delegator                      0.0007s 10984KB
  concurrent                                                         0.4029s 10988KB
  active_support/logger_silence                                      0.4127s 10988KB
  active_support/logger_thread_safe_level                            0.0006s 10996KB
  active_support/logger                                              0.4257s 11084KB
  active_support/core_ext/date_and_time/compatibility                0.0006s 11144KB
  active_support                                                     0.6941s 11144KB
  date_core                                                          0.0013s 11520KB
  date                                                               0.0020s 11520KB
  time                                                               0.0025s 11616KB
  active_support/core_ext/object/acts_like                           0.0003s 11616KB
  active_support/core_ext/time/acts_like                             0.0008s 11616KB
  base64                                                             0.0005s 11768KB
  bigdecimal                                                         0.0010s 11808KB
  active_support/multibyte                                           0.0004s 11812KB
  active_support/core_ext/string/multibyte                           0.0008s 11812KB
  active_support/inflector/transliterate                             0.0086s 11816KB
  active_support/core_ext/string/inflections                         0.0095s 11816KB
  active_support/core_ext/date_time/calculations                     0.0011s 11848KB
  active_support/core_ext/kernel/reporting                           0.0008s 11888KB
  active_support/core_ext/object/blank                               0.0017s 11888KB
  active_support/xml_mini/rexml                                      0.0113s 11888KB
  active_support/xml_mini                                            0.0429s 11888KB
  active_support/core_ext/hash/keys                                  0.0010s 11924KB
  active_support/core_ext/object/to_query                            0.0007s 11924KB
  active_support/core_ext/object/to_param                            0.0011s 11924KB
  active_support/core_ext/array/conversions                          0.0638s 11924KB
  active_support/core_ext/string/filters                             0.0007s 11936KB
  active_support/duration                                            0.0740s 11936KB
  tzinfo/ruby_core_support                                           0.0009s 12152KB
  tzinfo/offset_rationals                                            0.0006s 12196KB
  tzinfo/time_or_datetime                                            0.0012s 12224KB
  tzinfo/timezone_definition                                         0.0005s 12232KB
  tzinfo/timezone_offset                                             0.0006s 12232KB
  tzinfo/timezone_transition                                         0.0008s 12288KB
  tzinfo/timezone_transition_definition                              0.0006s 12288KB
  tzinfo/timezone_index_definition                                   0.0005s 12288KB
  tzinfo/timezone_info                                               0.0004s 12288KB
  tzinfo/data_timezone_info                                          0.0005s 12300KB
  tzinfo/linked_timezone_info                                        0.0004s 12300KB
  tzinfo/transition_data_timezone_info                               0.0013s 12428KB
  tzinfo/zoneinfo_timezone_info                                      0.0014s 12492KB
  tzinfo/data_source                                                 0.0009s 12532KB
  tzinfo/ruby_data_source                                            0.0008s 12548KB
  tzinfo/zoneinfo_data_source                                        0.0018s 12636KB
  tzinfo/timezone_period                                             0.0009s 12672KB
  thread_safe/version                                                0.0004s 12684KB
  thread_safe/synchronized_delegator                                 0.0006s 12684KB
  thread_safe                                                        0.0056s 12684KB
  thread_safe/non_concurrent_cache_backend                           0.0007s 12720KB
  thread_safe/mri_cache_backend                                      0.0014s 12720KB
  thread_safe/cache                                                  0.0026s 12720KB
  tzinfo/timezone                                                    0.0171s 12720KB
  tzinfo/info_timezone                                               0.0005s 12720KB
  tzinfo/data_timezone                                               0.0004s 12724KB
  tzinfo/linked_timezone                                             0.0005s 12724KB
  tzinfo/timezone_proxy                                              0.0006s 12736KB
  tzinfo/country_index_definition                                    0.0005s 12740KB
  tzinfo/country_info                                                0.0005s 12740KB
  tzinfo/ruby_country_info                                           0.0006s 12748KB
  tzinfo/zoneinfo_country_info                                       0.0013s 12748KB
  tzinfo/country                                                     0.0009s 12756KB
  tzinfo/country_timezone                                            0.0007s 12760KB
  tzinfo                                                             0.1486s 12760KB
  active_support/values/time_zone                                    0.1584s 12768KB
  active_support/core_ext/time/conversions                           0.1592s 12768KB
  active_support/time_with_zone                                      0.0026s 12868KB
  active_support/core_ext/date_and_time/zones                        0.0004s 12868KB
  active_support/core_ext/time/zones                                 0.0014s 12868KB
  active_support/core_ext/object/try                                 0.0007s 12884KB
  active_support/core_ext/date_and_time/calculations                 0.0023s 12884KB
  active_support/core_ext/date/zones                                 0.0005s 12884KB
  active_support/core_ext/date/calculations                          0.0058s 12884KB
  active_support/core_ext/time/calculations                          0.2757s 12884KB
  active_support/core_ext/module/redefine_method                     0.0008s 12884KB
  active_support/core_ext/time/compatibility                         0.0014s 12884KB
  active_support/core_ext/time                                       0.2999s 12888KB
  active_support/core_ext/date/acts_like                             0.0004s 12888KB
  active_support/core_ext/date/blank                                 0.0004s 12888KB
  active_support/core_ext/date/conversions                           0.0010s 12888KB
  active_support/core_ext/date                                       0.0134s 12904KB
  active_support/core_ext/date_time/acts_like                        0.0005s 12904KB
  active_support/core_ext/date_time/blank                            0.0005s 12904KB
  active_support/core_ext/date_time/compatibility                    0.0006s 12908KB
  active_support/core_ext/date_time/conversions                      0.0016s 12936KB
  active_support/core_ext/date_time                                  0.0145s 12936KB
  active_support/core_ext/numeric/time                               0.0013s 12980KB
  active_support/core_ext/integer/time                               0.0019s 12980KB
  active_support/core_ext/string/conversions                         0.0011s 13048KB
  active_support/core_ext/string/zones                               0.0005s 13048KB
  active_support/time                                                0.3730s 13048KB
  active_support/core_ext/string/starts_ends_with                    0.0004s 13172KB
  active_support/core_ext/string/access                              0.0005s 13172KB
  active_support/core_ext/string/behavior                            0.0009s 13344KB
  strscan                                                            0.0012s 13912KB
  erb                                                                0.0054s 13912KB
  active_support/multibyte/unicode                                   0.0032s 14188KB
  active_support/core_ext/string/output_safety                       0.0199s 14188KB
  active_support/core_ext/string/exclude                             0.0004s 14192KB
  active_support/core_ext/string/strip                               0.0004s 14196KB
  active_support/string_inquirer                                     0.0005s 14224KB
  active_support/core_ext/string/inquiry                             0.0009s 14224KB
  active_support/core_ext/string/indent                              0.0005s 14232KB
  activesupport-5.2.1/lib/active_support/core_ext/string.rb          0.0599s 14232KB
  active_support/inflector                                           0.0007s 14256KB
  active_support/core_ext/module/introspection                       0.0016s 14256KB
  active_support/core_ext/module/anonymous                           0.0006s 14256KB
  active_support/core_ext/module/reachable                           0.0008s 14260KB
  active_support/core_ext/module/attribute_accessors_per_thread      0.0011s 14284KB
  active_support/core_ext/module/attr_internal                       0.0008s 14296KB
  active_support/core_ext/module/concerning                          0.0007s 14320KB
  active_support/core_ext/module/remove_method                       0.0007s 14324KB
  activesupport-5.2.1/lib/active_support/core_ext/module.rb          0.0327s 14324KB
  activesupport-5.2.1/lib/active_support/core_ext/name_error.rb      0.0004s 14360KB
  active_support/core_ext/array/wrap                                 0.0004s 14376KB
  active_support/core_ext/array/access                               0.0005s 14400KB
  active_support/core_ext/array/grouping                             0.0006s 14416KB
  active_support/array_inquirer                                      0.0005s 14460KB
  active_support/core_ext/array/inquiry                              0.0009s 14460KB
  activesupport-5.2.1/lib/active_support/core_ext/array.rb           0.0141s 14460KB
  active_support/core_ext/class/attribute                            0.0011s 14516KB
  active_support/core_ext/class/subclasses                           0.0033s 14532KB
  activesupport-5.2.1/lib/active_support/core_ext/class.rb           0.0083s 14532KB
  active_support/core_ext/numeric/bytes                              0.0005s 14544KB
  active_support/core_ext/numeric/inquiry                            0.0004s 14544KB
  bigdecimal/util                                                    0.0006s 14552KB
  active_support/core_ext/big_decimal/conversions                    0.0014s 14552KB
  active_support/number_helper                                       0.0008s 14552KB
  active_support/core_ext/numeric/conversions                        0.0136s 14552KB
  activesupport-5.2.1/lib/active_support/core_ext/numeric.rb         0.0220s 14552KB
  activesupport-5.2.1/lib/active_support/core_ext/load_error.rb      0.0003s 14552KB
  activesupport-5.2.1/lib/active_support/core_ext/uri.rb             0.0005s 14552KB
  active_support/core_ext/integer/multiple                           0.0004s 14552KB
  active_support/core_ext/integer/inflections                        0.0005s 14556KB
  activesupport-5.2.1/lib/active_support/core_ext/integer.rb         0.0083s 14556KB
  active_support/core_ext/hash/compact                               0.0004s 14556KB
  active_support/core_ext/hash/reverse_merge                         0.0004s 14556KB
  active_support/core_ext/hash/conversions                           0.0055s 14556KB
  active_support/hash_with_indifferent_access                        0.0014s 14608KB
  active_support/core_ext/hash/indifferent_access                    0.0018s 14608KB
  active_support/core_ext/hash/transform_values                      0.0005s 14612KB
  activesupport-5.2.1/lib/active_support/core_ext/hash.rb            0.0236s 14612KB
  fileutils                                                          0.0073s 15424KB
  active_support/core_ext/file/atomic                                0.0079s 15424KB
  activesupport-5.2.1/lib/active_support/core_ext/file.rb            0.0081s 15424KB
  active_support/core_ext/range/conversions                          0.0004s 15444KB
  active_support/core_ext/range/include_range                        0.0004s 15448KB
  active_support/core_ext/range/include_time_with_zone               0.0005s 15464KB
  active_support/core_ext/range/overlaps                             0.0004s 15472KB
  active_support/core_ext/range/each                                 0.0005s 15476KB
  activesupport-5.2.1/lib/active_support/core_ext/range.rb           0.0164s 15476KB
  active_support/core_ext/kernel/agnostics                           0.0004s 15488KB
  active_support/core_ext/kernel/concern                             0.0007s 15488KB
  activesupport-5.2.1/lib/active_support/core_ext/kernel.rb          0.0091s 15492KB
  benchmark                                                          0.0015s 15572KB
  activesupport-5.2.1/lib/active_support/core_ext/benchmark.rb       0.0018s 15572KB
  active_support/core_ext/object/duplicable                          0.0010s 15640KB
  active_support/core_ext/object/deep_dup                            0.0006s 15684KB
  active_support/core_ext/object/inclusion                           0.0004s 15688KB
  active_support/core_ext/object/conversions                         0.0007s 15720KB
  active_support/core_ext/object/instance_variables                  0.0004s 15732KB
  json/version                                                       0.0004s 15968KB
  ostruct                                                            0.0011s 16076KB
  json/generic_object                                                0.0018s 16076KB
  json/common                                                        0.0079s 16076KB
  json/ext/parser                                                    0.0007s 16104KB
  json/ext/generator                                                 0.0008s 16188KB
  json/ext                                                           0.0061s 16188KB
  json                                                               0.0249s 16188KB
  active_support/core_ext/object/json                                0.0389s 16196KB
  active_support/option_merger                                       0.0008s 16252KB
  active_support/core_ext/object/with_options                        0.0017s 16252KB
  activesupport-5.2.1/lib/active_support/core_ext/object.rb          0.0667s 16252KB
  activesupport-5.2.1/lib/active_support/core_ext/marshal.rb         0.0004s 16272KB
  activesupport-5.2.1/lib/active_support/core_ext/enumerable.rb      0.0009s 16300KB
  activesupport-5.2.1/lib/active_support/core_ext/securerandom.rb    0.0005s 16332KB
  activesupport-5.2.1/lib/active_support/core_ext/big_decimal.rb     0.0003s 16348KB
  active_support/core_ext                                            0.3828s 16348KB
--------------------------------------------------------------------------------------
active_support/all                                                   1.4652s 16348KB
```

### archfiend
```
$ bundle exec analyze_requires archfiend
  name                                   time     RSS after
---------------------------------------------------------
  archfiend/version                      0.0010s  1648KB
  archfiend/application                  0.0031s  3024KB
  logger                                 0.0071s  4264KB
  bigdecimal                             0.0035s  4668KB
  oj/version                             0.0009s  4700KB
  oj/bag                                 0.0010s  4756KB
  oj/easy_hash                           0.0009s  4796KB
  oj/error                               0.0008s  4824KB
  ostruct                                0.0026s  5540KB
  oj/mimic                               0.0048s  5540KB
  oj/saj                                 0.0009s  5568KB
  oj/schandler                           0.0008s  5624KB
  date_core                              0.0029s  6096KB
  oj/oj                                  0.0139s  6428KB
  oj                                     0.0601s  6428KB
  archfiend/logging                      0.0719s  6428KB
  archfiend/logging/base_formatter       0.0009s  6444KB
  archfiend/logging/default_formatter    0.0007s  6456KB
  archfiend/logging/json_formatter       0.0007s  6468KB
  archfiend/logging/multi_logger         0.0008s  6488KB
  archfiend/shared_loop/runnable         0.0007s  6488KB
  archfiend/thread_loop                  0.0008s  6528KB
  archfiend/subprocess_loop              0.0010s  6568KB
---------------------------------------------------------
archfiend    0.1212s  6568KB
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gem_footprint_analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GemFootprintAnalyzer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gem_footprint_analyzer/blob/master/CODE_OF_CONDUCT.md).
