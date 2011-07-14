Rubylude
========

[Marc Chantreux](https://twitter.com/#!/marcchantreux) has written a lib to
emulate haskell lazyness in Perl:
[Perlude](https://github.com/eiro/p5-perlude). Rubylude is port of Perlude to
Ruby 1.9 that profits of the fibers.

Install
-------

```
gem install rubylude
```

Example
-------

To print the first 10 Fibonacci numbers that are a mutiple of 5, just do :

```ruby
require "rubylude"

fibo = ->() {
  a, b = 0, 1
  loop do
    a, b = b, a + b
    Fiber.yield a
  end
}

Rubylude.new(fibo).filter { |x| x % 5 == 0 }.take(10).traverse { |x| puts x }
```

Credits
-------

♡2011 by Bruno Michel. Copying is an act of love. Please copy and share.
