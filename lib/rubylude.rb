class Rubylude
  VERSION = "0.1.0"

  Infinity = 1.0 / 0

  # Generator: create a Rubylude from a lambda function
  def initialize(generator)
    @generator = Fiber.new { generator.call; nil }
  end

  # Generator: takes an array and inject one element at a time
  def self.unfold(values)
    Rubylude.new ->() {
      values.each {|v| Fiber.yield v }
    }
  end

  # Generator: inject these values indefinitely
  def self.cycle(values)
    Rubylude.new ->() {
      loop do
        values.each {|v| Fiber.yield v }
      end
    }
  end

  # Generator: generate values from `start` to `stop`, separated by `step`
  def self.range(start, stop=Infinity, step=1)
    Rubylude.new ->() {
      current = start - step
      if step > 0
        while (current += step) <= stop
          Fiber.yield current
        end
      else
        while (current += step) >= stop
          Fiber.yield current
        end
      end
    }
  end

  # Transformer: let pass only the elements that return true for the block
  def filter(&blk)
    Rubylude.new ->() {
      while value = @generator.resume
        Fiber.yield value if blk.call(value)
      end
    }
  end

  # Transformer: modify each element with the given block
  def apply(&blk)
    Rubylude.new ->() {
      while value = @generator.resume
        Fiber.yield blk.call(value)
      end
    }
  end

  # Transformer: let pass only the first `nb` elements
  def take(nb)
    Rubylude.new ->() {
      nb.times { Fiber.yield @generator.resume }
    }
  end

  # Transformer: if one element returns false, block it and all the following
  def takeWhile(&blk)
    Rubylude.new ->() {
      while value = @generator.resume
        return unless blk.call(value)
        Fiber.yield value
      end
    }
  end

  # Transformer: drop the first `nb` elements
  def drop(nb)
    Rubylude.new ->() {
      nb.times { @generator.resume }
      while value = @generator.resume
        Fiber.yield value
      end
    }
  end

  # Consumer: do an operation on each element
  def traverse(&blk)
    while value = @generator.resume
      blk.call(value)
    end
  end

  # Consumer: returns an array
  def to_a
    results = []
    traverse { |value| results << value }
    results
  end
end
