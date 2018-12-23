require 'minitest/autorun'
require 'time'

class StepOneTest < MiniTest::Test
  SAMPLE_INPUT = <<~LOG
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-01 00:30] falls asleep
    [1518-11-02 00:40] falls asleep
    [1518-11-01 00:05] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-01 00:25] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-05 00:55] wakes up
    [1518-11-03 00:24] falls asleep
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-03 00:29] wakes up
    [1518-11-01 00:55] wakes up
    [1518-11-04 00:36] falls asleep
    [1518-11-05 00:45] falls asleep
    [1518-11-04 00:46] wakes up
  LOG

  def test_parse
    events = SAMPLE_INPUT.lines.map(&Event.method(:from_s)).sort_by { |e| e.time }
    assert_equal Time.parse('1518-11-01 00:00'), events[0].time
    assert_equal 10, events[0].guard
    assert_equal :begin_shift, events[0].kind
    assert_equal :sleep, events[1].kind
    assert_equal :wake, events[2].kind
  end

  def test_fill
    events = SAMPLE_INPUT.lines.map(&Event.method(:from_s)).sort_by { |e| e.time }
    fill_guards(events)

    assert_equal 10, events[0].guard
    assert_equal 10, events[1].guard
  end

  def test_simple_input
    guard, minute = solve(SAMPLE_INPUT.lines.map(&method(:parse)))

    assert_equal 10 * 24, guard * minute
  end

  def test_complex_input
    guard, minute = solve2(SAMPLE_INPUT.lines.map(&method(:parse)))

    assert_equal 99 * 45, guard * minute
  end
end

def parse(line)
  Event.from_s(line)
end

def fill_guards(events)
  last_guard = nil
  events.each do |e|
    last_guard = e.guard if e.guard
    e.guard = last_guard
  end
end

def solve(schedule)
  events = schedule.sort_by { |e| e.time }
  fill_guards(events)

  sleepy = sleepy_guards(events.reject { |e| e.kind == :begin_shift })

  sleepiest_guard = max_sleepy(sleepy)

  [sleepiest_guard[0], sleepiest_guard[1][:sleepiest_minute]]
end

def solve2(schedule)
  events = schedule.sort_by { |e| e.time }
  fill_guards(events)

  sleepy = sleepy_guards(events.reject { |e| e.kind == :begin_shift })

  target = sleepy.max do |(_,a), (_,b)|
    a[:sleepiest_minute_count] <=> b[:sleepiest_minute_count]
  end
  [target[0], target[1][:sleepiest_minute]]
end

def input
  File.readlines('day4.input')
    .map(&method(:parse))
end
 
def max_sleepy(sleepy)
  sleepy.max do |(_, a), (_, b)|
    minutes = a[:minutes_asleep] <=> b[:minutes_asleep]
    if minutes == 0
      a[:distinct_minutes] <=> b[:distinct_minutes]
    else
      minutes
    end
  end
end

def sleepy_guards(events)
  base_sleeps = Hash.new { |hash, key| hash[key] = Hash.new { 0 } }
  events.each_slice(2).each_with_object(base_sleeps) do |(sleep_evt, wake_evt), sleeps|
    guard = sleep_evt.guard
    wake = wake_evt.time
    sleep = sleep_evt.time

    if (wake.day != sleep.day)
      wake = Time.new(sleep.year, sleep.month, sleep.day)
    end
    (sleep.min...wake.min).each { |m| sleeps[guard][m] += 1 }
  end
  @base_sleeps = base_sleeps
  base_sleeps.transform_values do |sleeps|
    minutes_asleep = sleeps.values.sum
    sleepiest_minute = sleeps.max { |a, b| a[1] <=> b[1] }[0]
    {
      minutes_asleep: minutes_asleep,
      sleepiest_minute: sleepiest_minute,
      distinct_minutes: sleeps.size,
      sleepiest_minute_count: sleeps[sleepiest_minute]
    }
  end
end

class Event
  attr_reader :time, :kind
  attr_accessor :guard

  def self.from_s(str)
    time, event_str = str.match(/\[(.+)\] (.+)\Z/).captures
    Event.new(Time.parse(time), event_str)
  end

  def initialize(time, event)
    @time = time
    @raw_event = event
    parse_event
  end

  def inspect
    "<Event guard=#{guard} kind=#{kind} time=#{time}>"
  end

  private
  def parse_event
    case @raw_event
    when 'falls asleep'
      @kind = :sleep
    when 'wakes up'
      @kind = :wake
    when /Guard #(\d+) begins shift/
      @kind = :begin_shift
      @guard = $1.to_i
    end
  end
end
