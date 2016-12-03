TEST_CASES = {
  'R2, L3' => {pos: [2, 3], dist: 5},
  'R2, R2, R2' => {pos: [0, -2], dist: 2},
  'R5, L5, R5, R3' => {dist: 12},
  'L1, L1, L1, L1' => {dist: 0},
  'L1, L1, L1, L1, L1' => {dist: 1}
}

TEST_CASES_2 = {
  'R8, R4, R4, R8' => {dist: 4}
}

def input
  File.readlines('day1.input')
    .flat_map(&method(:parse))
end

def parse(input)
  input.split(',').map(&Instruction.method(:new))
end

def run(instructions)
  start = Position.new(0, 0, 0)
  puts "__ -> #{start}"
  finish = instructions
    .flat_map(&:as_steps)
    .reduce(start) { |a, e| a.process(e) }

  puts "Distance: #{finish.distance_from_origin} :: #{finish}"
  finish.distance_from_origin
end

def run2(instructions)
  start = Position.new(0, 0, 0)
  instructions
    .flat_map(&:as_steps)
    .reduce([start]) do |a, e|
      n = a[0].process(e)
      puts n
      if (e != :left && e != :right && a.include?(n))
        return n.distance_from_origin
      else
        a.unshift(n)
      end
    end
end

def tests
  TEST_CASES.each do |path, expected|
    result = run(parse(path))
    if result == expected[:dist]
      puts "PASS"
    else
      puts "Expected #{expected[:dist]} got #{result}"
    end
  end
end

def tests2
  TEST_CASES_2.each do |path, expected|
    result = run2(parse(path))
    if result == expected[:dist]
      puts "PASS"
    else
      puts "Expected #{expected[:dist]} got #{result}"
    end
  end
end

HEADINGS = %w(N E S W)
Position = Struct.new(:x, :y, :heading) do
  # 0 = north, 1 = east, 2 = south, 3 = west
  def to_s
    "#{x},#{y}:#{HEADINGS[heading] || 'X'}"
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def new_heading(instruction)
    case instruction
    when :left
      (heading - 1) % 4
    when :right
      (heading + 1) % 4
    end
  end

  def new_position
    case heading
    when 0
      [x, y + 1]
    when 1
      [x + 1, y]
    when 2
      [x, y - 1]
    when 3
      [x - 1, y]
    end
  end

  def trail_to(x1, y1)
    if (x == x1) # trail is along y
      (y..y1).map { |yy| [x, yy] }
    else # trail is along x
      (x..y1).map { |yy| [x, yy] }
    end
  end

  def process(instruction)
    case instruction
    when :left, :right
      h1 = new_heading(instruction)
      self.class.new(x, y, h1)
    when :walk
      x1, y1 = new_position
      self.class.new(x1, y1, heading)
    else
      self
    end
  end

  def distance_from_origin
    x.abs + y.abs
  end

  def trail
    @trail
  end
end

Instruction = Struct.new(:turn, :distance) do
  def initialize(s)
    enc = s.strip
    super(enc[0], enc[1..-1].to_i)
  end

  TURNS = { 'L' => :left, 'R' => :right }
  def as_steps
    [TURNS[turn]] + ([:walk] * distance)
  end

  def to_s
    "#{turn}#{distance}"
  end
end

