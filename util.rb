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
