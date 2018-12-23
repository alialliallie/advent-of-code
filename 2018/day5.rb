require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_simple_input
    micro = 'aA'
    assert_equal '', react(micro), micro
    mini = 'abBa'
    assert_equal 'aa', react(mini), mini
    mini2 = 'abAB'
    assert_equal 'abAB', react(mini2), mini2
    small = 'aabAAB'
    assert_equal 'aabAAB', react(small), small
    sample = 'dabAcCaCBAcCcaDA'
    assert_equal 'dabCBAcaDA', react(sample), sample
  end

  def test_complex_input
    sample = 'dabAcCaCBAcCcaDA'
    assert_equal 4, optimize(sample)
  end
end

def parse(line)
  line
end

def react(input)
  seq = input.dup
  i = 0
  while i < seq.size
    break if seq[i + 1].nil?
    break if seq.size.zero?

    # Magic distance between case ordinals
    if (seq[i].ord - seq[i + 1].ord).abs == 32
      seq.slice!(i, 2)
      # Backtrack to see if that causes a new removal
      i = (i - 1).clamp(0, seq.size)
    else
      i += 1
    end
  end
  seq
end

def optimize(input)
  ('A'..'Z').reduce(input.size) do |min, polymer|
    inverse = (polymer.ord + 32).chr
    test = react(input.gsub(/[#{polymer}#{inverse}]/, ''))
    [min, test.size].min
  end
end

def input
  File.read('day5.input')
end
