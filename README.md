# time_in_words

All code stolen from [lucky framework time_helpers](https://github.com/luckyframework/lucky/blob/main/src/lucky/page_helpers/time_helpers.cr), but added the Chinese support.

Only EN and ZH_CN supported for now, PR is welcome.

The locale name will follow name in [this](https://github.com/crystal-i18n/i18n/blob/a0d6276114a31f233cfec4ac928a01051ab01aa2/src/i18n/pluralization.cr#L33-L178) file.

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

TimeHelper.from(time: Time.local - 13.months) # => "大约一年前"

from_time = Time.local
TimeHelper.distance(from: from_time, to: from_time + 50.minutes) # => "大约一个小时"
TimeHelper.distance(from: from_time, to: from_time + 35.minutes) # => "35 分钟"

span = 4.minutes
TimeHelper.distance(span: span) # => "四分钟"

TimeHelper.distance(span: Time::Span.zero) # => "零秒"
TimeHelper.from(time: Time.utc)            # => "刚刚"
```

Check the [time_in_words_en_spec.cr](spec/time_in_words_en_spec.cr) for usage about English time words.

In both languages, `distance` returns only the duration, regardless of the order
of its dates or the sign of its span. `from` adds `ago` / `前` for past times and
`in` / `后` for future times; the Chinese result for the current moment is `刚刚`.

Both methods describe elapsed duration rather than calendar date differences.
Day-level descriptions use Rails-style rounding: 60 hours becomes 3 days,
regardless of the input time zones. Second, month, and year descriptions keep
their existing rules.

```crystal
now = Time.utc(2026, 10, 20, 14)
posted_at = now - 60.hours

TimeHelper.from(time: posted_at, now: now) # => "三天前"
```

`now` is optional and defaults to the current time. Pass it when you need a fixed
reference time, such as in tests or when rendering several timestamps together.

Year descriptions follow Rails' approximate / over / almost thresholds. Date
pairs account for leap days; a bare `Time::Span` uses fixed 365-day years because
it has no calendar dates.

```crystal
alias EnglishTimeHelper = TimeInWords::Helpers(TimeInWords::I18n::EN)

EnglishTimeHelper.from(time: Time.utc - 2.hours) # => "about 2 hours ago"
EnglishTimeHelper.distance(span: 2.hours)       # => "about 2 hours"
```

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
