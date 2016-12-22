require 'minitest/autorun'
require 'digest/md5'

class StepOneTest < MiniTest::Test
  def test_simple_input
    seq = MD5Seq.new('abc')
    assert_equal '1', seq.next
    assert_equal 3231929, seq.counter
    n = seq.next
    assert_equal 5017308, seq.counter
    assert_equal '8', n
    assert_equal 'f', seq.next
    assert_equal 5278568, seq.counter
  end
end

def solve(lines)
  seq = MD5Seq.new(lines)
  passwd = ''
  8.times do
    passwd << seq.next
  end
  passwd
end

def solve2(lines)
  seq = PositionalMD5Seq.new(lines)
  passwd = Array.new(8) { nil }
  begin
    pos, digit = seq.next2
    passwd[pos] ||= digit
  end until passwd.count { |c| c.nil? } == 0
  passwd.join
end

def input
  'cxdnnyjw'
end

class MD5Seq
  attr_reader :code, :counter

  def initialize(code)
    @code = code
    # Initialize to -1 so first check is 0
    @counter = -1
  end

  def next
    begin
      @counter += 1
    end until digit?
    result
  end

  def result
    digest[5]
  end

  def digest
    text = "#{@code}#{@counter}"
    Digest::MD5.hexdigest(text)
  end

  def digit?
    /^0{5}/.match(digest)
  end
end

class PositionalMD5Seq < MD5Seq
  def digit?
    /^0{5}[0-7]/.match(digest)
  end

  def result
    [digest[5].to_i, digest[6]]
  end
end
