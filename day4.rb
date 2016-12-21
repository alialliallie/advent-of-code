require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
    room = Room.parse('aaaaa-bbb-z-y-x-123[abxyz]')
    assert_equal('aaaaa-bbb-z-y-x', room.encrypted_name)
    assert_equal(123, room.sector)
    assert_equal('abxyz', room.checksum)
  end

  def test_real_room
    assert(Room.parse('aaaaa-bbb-z-y-x-123[abxyz]').real?, 'abxyz')
    assert(Room.parse('a-b-c-d-e-f-g-h-987[abcde]').real?, 'abcde')
    assert(Room.parse('not-a-real-room-404[oarel]').real?, 'oarel')
    assert(!Room.parse('totally-real-room-200[decoy]').real?, 'decoy')
  end

  def test_complex_input
    room = Room.parse('qzmt-zixmtkozy-ivhz-343[abcde]')
    assert_equal 'very encrypted name', room.name
  end
end

def solve(rooms)
  rooms.find_all(&:real?).map(&:sector).reduce(&:+)
end

def solve2(rooms)
  rooms.find_all(&:real?).map { |r| [r.name, r.sector] }
end

def input
  File.readlines('day4.input')
    .map(&Room.method(:parse))
end

Room = Struct.new(:encrypted_name, :sector, :checksum) do
  def self.parse(formatted)
    segments = formatted.strip.split('-')
    # Final segment should be sector[chksum]
    name = segments[0..-2].join('-')
    sector, checksum = /([0-9]+)\[([a-z]+)\]/.match(segments[-1])[1..2]
    Room.new(name, sector.to_i, checksum)
  end

  def real?
    sorted_letters.take(5).join == checksum
  end

  def sorted_letters
    letters = encrypted_name.gsub(/[^a-z]/,'').chars
    letters
      .lazy
      .group_by {|c| c}
      .map { |(c, cs)| [c, cs.length] }
      .sort do |(la, na), (lb, nb)|
        if na == nb
          lb <=> la
        else
          na <=> nb
        end
      end
      .reverse
      .map(&:first)
      .to_a
  end

  # decrypted name
  def name
    shift = sector % 26
    encrypted_name.chars.map do |c|
      if c == '-'
        ' '.ord
      else
        n = c.ord - 'a'.ord # map 0-25
        (n + shift) % 26 + 'a'.ord
      end
    end.map(&:chr).join
  end
end
