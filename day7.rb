require 'minitest/autorun'
require './util'

class StepOneTest < MiniTest::Test
  def test_simple_input
    assert Address.new('abba[mnop]qrst').supports_tls?, 'abba'
    refute Address.new('abcd[bddb]xyyx').supports_tls?, 'abcd'
    refute Address.new('aaaa[qwer]tyui').supports_tls?, 'aaaa'
    assert Address.new('ioxxoj[asdfgh]zxcvbn').supports_tls?, 'ioxx'
  end

  def test_spots
    assert Address.new('vowrlwyrxwivzacnop[fegbzczrceczdasjr]orroaksljdcydlk[clwvvrdfhommqcn]yqigbtlwvklqxxiors[uliodgyotgxdymyi]lqverjsyuxifpjoru').supports_tls?
  end

  def test_complex_input
    assert Address.new('aba[bab]xyz').supports_ssl?, 'aba'
    refute Address.new('xyx[xyx]xyx').supports_ssl?, 'xyx'
    assert Address.new('aaa[kek]eke').supports_ssl?, 'aaa'
    assert Address.new('zazbz[bzb]cdb').supports_ssl?, 'zaz'
  end
end


def solve lines
  lines.count(&:supports_tls?)
end

def solve2 lines
  lines.count(&:supports_ssl?)
end

def input
  File.readlines('day7.input').map(&Address.method(:new))
end

class Address
  ABBA = /(\w)(?!\1)(\w)\2\1/
  ABA = /(\w)(?!\1)(\w)\1/

  attr_reader :full, :supernet, :hypernet
  def initialize addr
    @hypernet = addr.scan(/\[\w+\]/).map { |h| h.gsub(/\[|\]/, '') }
    @supernet = addr.split(/\[\w+\]/)
    @addr = addr
  end

  def supports_tls?
    in_supernet = @supernet.any? { |seq| ABBA.match seq }
    in_hypernet = @hypernet.any? { |seq| ABBA.match seq }
    in_supernet && !in_hypernet
  end

  def supports_ssl?
    # Array of match data that needs to get flipped
    abas = @supernet.flat_map do |seq| 
      Sequences.slices(seq.chars, 3).map do |sl|
        ABA.match sl.join
      end
    end.compact.uniq
    babs = abas.map(&method(:flip))
    babs.find { |m| @hypernet.any? { |seq| m.match seq } }
  end

  def flip match
    a = match[1]
    b = match[2]
    /#{b}#{a}#{b}/
  end

end

# abba: orro 
# hyper: [fegbzczrceczdasjr]orroaksljdcydlk[clwvvrdfhommqcn]yqigbtlwvklqxxiors[uliodgyotgxdymyi]

