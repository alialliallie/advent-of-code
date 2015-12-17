def sample
  ["Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.",
   "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."]
    .map(&method(:parse))
end

def input
  File.readlines('day14.input')
    .map(&method(:parse))
end

def solve(deer, time = 2503)
    deer.map { |r| r.distance_after(time) }.max
end

def solve2(deer, time = 2503)
  (1..time).each_with_object(Hash.new(0)) do |t, points|
    by_t = deer.group_by { |r| r.distance_after(t) }
    firsts = by_t[by_t.keys.max]
    firsts.each { |f| points[f] += 1 }
  end
end

def parse(deer)
  flying = /(?<name>\S+) can fly (?<speed>\d+) km\/s for (?<fly_t>\d+) seconds/
  resting = /but then must rest for (?<rest_t>\d+) seconds\./
  m = /#{flying}, #{resting}/.match(deer)
  Reindeer.new(m[:name], m[:speed].to_i, m[:fly_t].to_i, m[:rest_t].to_i)
end

class Reindeer
  attr_reader :name, :speed, :fly_t, :rest_t

  def initialize(name, speed, fly_t, rest_t)
    @name = name
    @speed = speed
    @fly_t = fly_t
    @rest_t = rest_t
  end

  def distance_after(s)
    full, partial = s.divmod(fly_t + rest_t)
    d = full * dist(fly_t)
    d + (partial < fly_t ? dist(partial) : dist(fly_t))
  end

  def dist(s)
    speed * s
  end
end
