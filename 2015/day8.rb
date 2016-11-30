def input(file = 'day8.input')
  File.readlines(file).map(&:chomp)
end

def solve(input)
  r = input.map(&method(:count_chars))
  raw = r.map { |p| p[0] }.reduce(:+)
  code = r.map { |p| p[1] }.reduce(:+)
  enc = r.map { |p| p[2] }.reduce(:+)
  {
    raw: raw,
    code: code,
    enc: enc
  }
end

def count_chars(str)
  raw = str.length
  code = eval(str).length
  enc = bloat(str)
  [raw, code, enc]
end

# str length
# + 1 per "
# + 1 per \
# + 2 for outside "
def bloat(str)
  ch = str.chars
  str.length + ch.count { |c| c == '"' } + ch.count { |c| c == '\\' } + 2
end
