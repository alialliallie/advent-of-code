def solve
  File
    .readlines('day6.input')
    .map(&method(:parse))
    .reduce([[false] * 1000] * 1000) { |a, e| run(a, e) }
    .flatten
    .count(&:itself)
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
      lights[x] = on(lights[x], from[1], to[1])
    when 'turn off'
      lights[x] = off(lights[x], from[1], to[1])
    when 'toggle'
      lights[x] = toggle(lights[x], from[1], to[1])
    end
  end
  lights
end

def on(row, f, t)
  row[0..(f - 1)] + ([true] * (t - f + 1)) + row[(t + 1)..-1]
end

def off(row, f, t)
  row[0..(f - 1)] + ([false] * (t - f + 1)) + row[(t + 1)..-1]
end

def toggle(row, f, t)
  row[0..(f - 1)] + row[f..t].map(&:!) + row[(t + 1)..-1]
end

def dump(lights)
  lights.map { |row| row.map { |l| l ? 'O' : '_' }.join('') }.join("\n")
end
