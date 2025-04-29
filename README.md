# time_in_words

All code stolen from [lucky framework time_helpers](https://github.com/luckyframework/lucky/blob/main/src/lucky/page_helpers/time_helpers.cr), but added the Chinese support.

Only EN and ZH_CN supported for now, PR is welcome.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     time_in_words:
       github: crystal_china/time_in_words
   ```

2. Run `shards install`

## Usage

```crystal
require "time_in_words"

alias TimeHelper = TimeInWords::Helpers(TimeInWords::I18n::ZH_CN)

TimeHelper.from(past_time: Time.local - 13.months) # => "大约一年前"

from_time = Time.local
TimeHelper.distance(from: from_time, to: from_time + 50.minutes) # => "大约一个小时前"
TimeHelper.distance(from: from_time, to: from_time + 35.minutes) # => "35 分钟前"

span = 4.minutes
TimeHelpers.distance(span: span) # => "四分钟前"
```

Check the [time_in_words_en_spec.cr](spec/time_in_words_en_spec.cr) for usage about English time words.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/zw963/time_in_words/fork>)
2. Run `make` to ensure spec passed.
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run `make` again to ensure spec passed.
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Billy.Zheng](https://github.com/zw963) - creator and maintainer
