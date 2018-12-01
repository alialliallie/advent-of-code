require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
    assert_equal [:up, :down, :left, :right], parse("UDLR\n")
  end

  def test_move
    start = Position.new(2,2)
    assert_equal '5', keypad(start)
    assert_equal '2', keypad(start.move(:up, KEYPAD)), 'up'
    assert_equal '8', keypad(start.move(:down, KEYPAD)), 'down'
    assert_equal '4', keypad(start.move(:left, KEYPAD)), 'left'
    assert_equal '6', keypad(start.move(:right, KEYPAD)), 'right'
  end

  def test_single_input
    assert_equal '1', keypad(digit(parse("ULL"), Position.new(2,2), KEYPAD))
    assert_equal '9', keypad(digit(parse("RRDDD"), Position.new(1,1), KEYPAD))
    assert_equal '8', keypad(digit(parse("LURDL"), Position.new(3,3), KEYPAD))
    assert_equal '5', keypad(digit(parse("UUUUD"), Position.new(3,2), KEYPAD))
  end

  def test_simple_input
    instr = ["ULL", "RRDDD", "LURDL", "UUUUD"]
    assert_equal '1985', solve(instr.map(&method(:parse)))
  end

  def test_complex_input
    instr = ["ULL", "RRDDD", "LURDL", "UUUUD"]
    assert_equal '5DB3', solve2(instr.map(&method(:parse)))
  end
end

LOOKUP = { "U" => :up, "D" => :down, "L" => :left, "R" => :right }
def parse(line)
  line.strip.chars.map { |c| LOOKUP[c] }
end

def solve(lines)
  start = Position.new(2, 2)
  lines.reduce({pos: start, code: []}) do |a, e|
    finish = digit(e, a[:pos], KEYPAD)
    {code: a[:code] + [KEYPAD[finish.x][finish.y]],
     pos: finish}
  end[:code].join
end

def solve2(lines)
  start = Position.new(2, 0)
  lines.reduce({pos: start, code: []}) do |a, e|
    finish = digit(e, a[:pos], KEYPAD2)
    {code: a[:code] + [KEYPAD2[finish.x][finish.y]],
     pos: finish}
  end[:code].join
end

def input
  File.readlines('day2.input')
    .map(&method(:parse))
end

def digit(path, start, kp)
   path.reduce(start) { |a, e| a.move(e, kp) }
end

def keypad(position)
  KEYPAD[position.x][position.y]
end

# [[0, 1, 2]  0
#  [0, 1, 2]  1
#  [0, 1, 2]] 2

# start 1, 1
KEYPAD = [
#    0 1 2 3 4
  %w(_ _ _ _ _), # 0
  %w(_ 1 2 3 _), # 1
  %w(_ 4 5 6 _),
  %w(_ 7 8 9 _),
  %w(_ _ _ _ _)
]
KEYPAD2 = [
  %w(_ _ 1 _ _),
  %w(_ 2 3 4 _),
  %w(5 6 7 8 9),
  %w(_ A B C _),
  %w(_ _ D _ _)
]

Position = Struct.new(:x, :y) do
  def move(where, kp)
    case where
    when :up
      n = self.class.new([x - 1, 0].max, y)
    when :down
      n = self.class.new([x + 1, 4].min, y)
    when :left
      n = self.class.new(x, [y - 1, 0].max)
    when :right
      n = self.class.new(x, [y + 1, 4].min)
    end
    kp[n.x][n.y] == '_' ? self : n
  end
end

