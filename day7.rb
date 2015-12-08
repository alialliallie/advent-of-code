require 'pp'
# Emotes lol
OPERS = {
  "AND" => :&,
  "OR" => :|,
  "LSHIFT" => :<<,
  "RSHIFT" => :>>
}

def solve
  machine = make('day7.input')
  run(machine)["a"]
end

def solve2
  part1 = solve
  machine = make('day7.input')
  machine["b"] = Instruction.new "#{part1} -> b"
  run(machine)["a"]
end

def make(file)
  File
    .readlines(file)
    .map { |l| Instruction.new(l) }
    .each_with_object({}) { |e, a| a[e.wire] = e }
end

def sample(input)
  machine = input.split("\n")
    .map { |l| Instruction.new(l) }
    .each_with_object({}) { |e, a| a[e.wire] = e }
  run(machine)
end

def run(machine)
  step = 0
  solved = {}
  while machine.size != solved.size
    puts "STEP #{step}"
    print_machine(machine)
    machine.reject { |_k, v| v.solved? }
    .each do |k, v|
      if v.can_run?(solved)
        solved[k] = v.run(solved)
      end
    end
    step += 1
  end
  solved
end

class Instruction
  attr_reader :wire, :expr, :op
  attr_accessor :lval, :rval

  def initialize(line)
    m = line.match(/(.+) -> ([a-z]+)/)
    @wire = m[2]
    @expr = m[1]
    parse
  end

  def solved?
    @solved
  end

  def parse
    if i = try_int(expr)
      @lval = i
    elsif m = expr.match(/NOT ([a-z0-9]+)/)
      @op = :~
      @lval = try_int(m[1]) || m[1]
    elsif m = expr.match(/([a-z0-9]+) (.+) ([a-z0-9]+)/)
      @lval = try_int(m[1]) || m[1]
      @op = OPERS[m[2]]
      @rval = try_int(m[3]) || m[3]
    else
      # This is when LHS of input is just a wire
      @lval = expr
    end
  end

  def can_run?(solved)
    has_lval = lval.is_a?(Integer) || 
      lval.is_a?(String) && solved.has_key?(lval)
    has_rval = rval.nil? || (
      rval.is_a?(Integer) || 
      rval.is_a?(String) && solved.has_key?(rval)
    )

    has_lval && has_rval
  end

  # Attempt to run this instruction
  # Does nothing if not able to
  def run(solved)
    if op == :~
      puts "running #{self}"
      @solved = true
      lval_from(solved).send(op)
    elsif op 
      puts "running #{self}"
      @solved = true
      lval_from(solved).send(op, rval_from(solved))
    else
      puts "running #{self}"
      @solved = true
      lval_from(solved)
    end
  end

  def lval_from(solved)
    return lval if lval.is_a?(Integer)
    solved[lval]
  end

  def rval_from(solved)
    return rval if rval.is_a?(Integer)
    solved[rval]
  end

  def to_s
    "#{wire} = #{lval} #{op} #{rval}"
  end
end

def print_machine(machine)
  machine.map { |_k, v| v.to_s }.join("\n")
end

def try_int(str)
  Integer(str)
rescue ArgumentError
  nil
end
