module Counting
  module_function
  def histogram(seq)
    counts = seq
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
    Hash[counts]
  end
end

module Sequences
  module_function
  def slices(seq, size)
    fail ArgumentError if size > seq.length
    max_start = seq.length - size
    (0..max_start).each_with_object([]) do |start, set|
      set << seq.slice(start, size)
    end
  end
end
