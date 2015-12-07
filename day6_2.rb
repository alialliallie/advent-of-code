def solve
  File
    .readlines('day6.input')
    .map(&method(:parse))
    .reduce([[0] * 1000] * 1000) { |a, e| run(a, e) }
    .flatten
    .reduce(&:+)
end

TASK_REGX = /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
def parse(task)
  m = task.match TASK_REGX
  {
    op: m[1],
    from: [m[2].to_i, m[3].to_i],
    to: [m[4].to_i, m[5].to_i]
  }
end

def run(lights, inst)
  from = inst[:from]
  to = inst[:to]
  from[0].upto(to[0]) do |x|
    case inst[:op]
    when 'turn on'
      lights[x] = modify(lights[x], from[1], to[1], 1)
    when 'turn off'
      lights[x] = modify(lights[x], from[1], to[1], -1)
    when 'toggle'
      lights[x] = modify(lights[x], from[1], to[1], 2)
    end
  end
  lights
end

def modify(row, f, t, by)
  row[0..(f - 1)] + row[f..t].map { |x| [0, x + by].max } + row[(t + 1)..-1]
end

def dump(lights)
  lights.map { |row| row.join(' ') }.join("\n")
end
