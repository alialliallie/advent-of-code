require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
    claim = Claim.from_s("#123 @ 3,2: 5x4")
    assert_equal(123, claim.id)
    assert_equal(3, claim.left)
    assert_equal(2, claim.top)
    assert_equal(5, claim.width)
    assert_equal(4, claim.height)
  end

  def test_simple_input
    claims = ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"].map(&Claim.method(:from_s))
    assert_equal(4, solve(claims))
  end

  def test_complex_input
    claims = ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"].map(&Claim.method(:from_s))
    assert_equal(3, solve2(claims).id)
  end
end

def parse(line)
  Claim.from_s(line)
end

def solve(claims)
  max_x = claims.map(&:right).max
  max_y = claims.map(&:bottom).max

  overlap = 0
  (0..max_x).each do |x|
    (0..max_y).each do |y|
      overlap += 1 if claims.count { |c| c.contains? x, y } > 1
    end
  end
  overlap
end

def solve2(claims)
  # claims.find_all do |c|
  claims.find do |c|
    claims.none? { |o| c.overlap? o }
  end
end

def input
  File.readlines('day3.input')
    .map(&method(:parse))
end

class Claim
  attr_accessor :id, :left, :top, :width, :height, :right, :bottom

  def initialize(id, left, top, width, height)
    @id = id
    @left = left
    @top = top
    @width = width
    @height = height
    @right = left + width
    @bottom = top + height
  end

  def self.from_s(str)
    id, left, top, width, height = str.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).captures
    Claim.new(id.to_i, left.to_i, top.to_i, width.to_i, height.to_i)
  end

  def overlap?(other)
    return false if id == other.id

    other.left < right &&
      other.right > left &&
      other.top < bottom &&
      other.bottom > top
  end

  def contains?(x, y)
    x >= left && x < right && y >= top && y < bottom
  end
end