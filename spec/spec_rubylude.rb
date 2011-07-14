#!/usr/bin/env ruby

require "minitest/autorun"
require "rubylude"


describe Rubylude do

  it "has a version number" do
    Rubylude::VERSION.must_match /\d+\.\d+\.\d+/
  end

  it "can compute the first 5 fibonacci numbers that are a multiple of 5" do
    fibo = ->() {
      a, b = 0, 1
      loop do
        a, b = b, a + b
        Fiber.yield a
      end
    }
    results = Rubylude.new(fibo).filter { |x| x % 5 == 0 }.take(5).to_a
    results.must_equal [5, 55, 610, 6765, 75025]
  end

  it "can unfold values" do
    values = %w(a b c d e f)
    Rubylude.unfold(values).to_a.must_equal values
  end

  it "can cycle on values" do
    Rubylude.cycle(1..3).take(10).to_a.must_equal [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]
  end

  it "can use a range as a generator" do
    Rubylude.range(2, 10, 2).to_a.must_equal [2, 4, 6, 8, 10]
    Rubylude.range(3).take(3).to_a.must_equal [3, 4, 5]
  end

  it "can filter even numbers" do
    Rubylude.unfold(1..10).filter { |n| n % 2 == 0 }.to_a.must_equal [2, 4, 6, 8, 10]
  end

  it "can multiply each element by 3" do
    Rubylude.unfold(1..3).apply { |n| n * 3 }.to_a.must_equal [3, 6, 9]
  end

  it "can take elements up to the end marker" do
    values = %w(foo bar baz END qux courge)
    results = Rubylude.unfold(values).takeWhile {|v| v != "END" }.to_a 
    results.must_equal values[0..2]
  end

  it "can drop the first 3 elements" do
    Rubylude.unfold(1..6).drop(3).to_a.must_equal [4, 5, 6]
  end

  it "can sum elements with sum" do
    sum = 0
    Rubylude.unfold(1..10).traverse {|v| sum += v }
    sum.must_equal 55
  end

end
