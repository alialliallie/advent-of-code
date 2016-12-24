require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
    assert_equal 'rect 3x2', Command.parse('rect 3x2').to_s
    assert_equal 'rotate x=1 by 1', Command.parse('rotate column x=1 by 1').to_s
    assert_equal 'rotate y=0 by 4', Command.parse('rotate row y=0 by 4').to_s
  end

  def test_simple_input
    board = Board.new(7, 3)
    b = Command.parse('rect 3x2').apply(board)
    assert_equal "###....\n###....\n.......", b.to_s, 'rect 3x2'
    b = Command.parse('rotate column x=1 by 1').apply(b)
    assert_equal "#.#....\n###....\n.#.....", b.to_s, 'rotate x1 by 1'
    b = Command.parse('rotate row y=0 by 4').apply(b)
    assert_equal "....#.#\n###....\n.#.....", b.to_s, 'rotate y0 by 4'
    b = Command.parse('rotate column x=1 by 1').apply(b)
    assert_equal ".#..#.#\n#.#....\n.#.....", b.to_s, 'rotate x1 by 1 again'
  end

  def test_complex_input
  end
end

def parse(line)
  Command.parse(line)
end

def solve(commands)
  board = Board.new(50, 6)
  commands.reduce(board) { |b, cmd| cmd.apply(b) }.count
end

def solve2(commands)
  board = Board.new(50, 6)
  commands.reduce(board) { |b, cmd| cmd.apply(b) }
end

def input
  File.readlines('day8.input')
    .map(&method(:parse))
end

class Command
  def self.parse text
    operation, arguments = text.split(" ", 2)
    case operation
    when 'rect'
      RectCommand.new(arguments)
    when 'rotate'
      RotateCommand.new(arguments)
    end
  end
end

class RectCommand
  attr_reader :x, :y
  def initialize(size)
    @x, @y = size.split('x').map(&:to_i)
  end

  def to_s
    "rect #{x}x#{y}"
  end

  def apply(board)
    new_board = board.dup
    x.times do |x|
      y.times do |y|
        new_board.set(x, y, true)
      end
    end
    new_board
  end
end

class RotateCommand
  attr_reader :axis, :n, :dist
  PATTERN = /(\w+) ([xy])=(\d+) by (\d+)/
  def initialize args
    m = PATTERN.match args
    @axis = m[2].to_sym
    @n = m[3].to_i
    @dist = m[4].to_i
  end

  def to_s
    "rotate #{axis}=#{n} by #{dist}"
  end

  def apply(board)
    b = board.dup
    stuff = b.get(axis, n)
    rotated = stuff.rotate(-dist)
    b.load(axis, n, rotated)
    b
  end
end

class Board
  def initialize(x, y)
    @bits = Array.new(y) { Array.new(x) { nil }}
  end

  def dup
    b = Board.new(0,0)
    b.bits = @bits.map(&:dup)
    b
  end

  def set x, y, state
    @bits[y][x] = state
  end

  def get axis, n
    case axis
    when :y
      @bits[n].dup
    when :x
      @bits.each_with_object(n).map(&:[])
    end
  end

  def load axis, n, bits
    case axis
    when :y
      @bits[n] = bits.dup
    when :x
      bits.each_with_index do |b, i|
        @bits[i][n] = b
      end
    end
  end

  def count
    @bits.reduce(0) { |a, e| a + e.compact.length }
  end

  def to_s
    @bits.map { |y|
      y.map { |x| x ? "#" : "." }.join
    }.join "\n"
  end

  def inspect
    "<Board\n#{to_s}\n>"
  end

  protected
  def bits= bits
    @bits = bits
  end
end
