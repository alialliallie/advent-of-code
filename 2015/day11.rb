def run
  first = solve('cqjxjnds')
  puts "first: #{first}"
  puts "second: #{solve(first)}"
end

def solve(initial)
  next_pw = initial.next
  until valid?(next_pw) do
    next_pw = next_pw.next
  end
  next_pw
end

def valid?(password)
  return false if password.match(/[iol]/)
  return false unless password.scan(/(.)\1/).uniq.size >= 2
  run? password
end

def run?(password)
  password.chars
    .each_cons(3)
    .any? do |p|
      p[1] == p[0].next && p[2] == p[1].next
    end
end
