# Sigmund

*Sign urls and verify signatures*

## Installation

Add this line to your application's Gemfile:

    gem 'sigmund'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sigmund

## Usage

To sign a url, use:

    Sigmund.sign("http://www.test.com/path", 'secret_key')

This will append a `sig` parameter to the url containing a HMAC SHA1 signature.

Now to verify a signature, use:

    Sigmund.verify("http://www.test.com/path?sig=ZCqYKJiLS7WMZX7l5wEU016Mv1s", 'secret_key')

This will return `true` only if a valid signature is present.

NB: *By default Sigmund ignores the url scheme and host.*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Plans

* Add date range verification
* Add ip range verification
* Integration with ActionController

## License
Sigmund is licensed under the terms of the MIT License, see the included LICENSE file.

## Authors
- [Leo Vandriel](http://www.leovandriel.com/)
