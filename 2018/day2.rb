require 'minitest/autorun'
require_relative 'util'

class StepOneTest < MiniTest::Test
  def test_simple_input
    codes = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
    checksum = Advent.checksum(codes)
    assert_equal(12, checksum)
  end

  def test_complex_input
    codes = ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']
    pair = Advent.hamming_one(codes)

    assert_equal(pair, ['fghij', 'fguij'])

    common = Advent.common_id(pair)
    assert_equal(common, 'fgij')
  end
end

module Advent
  def self.parse(line)
    line
  end

  def self.checksum(lines)
    counts = lines.map {|l| Counting.histogram(l.each_char).values.uniq}
    twos = counts.count { |a| a.include? 2}
    threes = counts.count { |a| a.include? 3}
    twos * threes
  end

  def self.hamming_one(lines)
    lines.combination(2).find do |(a, b)|
      Advent.hamming(a, b) == 1
    end
  end

  def self.hamming(a, b)
    a.chars.zip(b.chars).count {|left, right| left != right}
  end

  def self.common_id(pair)
    a, b = pair
    a.chars.zip(b.chars).find_all {|left, right| left == right}.map(&:first).join
  end

  def self.solve(lines)
    self.checksum(lines)
  end

  def self.solve2(lines)
    pair = hamming_one(lines)
    common_id(pair)
  end

  def self.input
    File.readlines('day2.input')
      .map(&method(:parse))
  end
end