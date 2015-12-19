def sample
  [
    "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
    "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"
  ].map { |l| Ingredient.parse(l) }
end

def input
  [
    "Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2",
    "Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9",
    "Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1",
    "Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8"
  ].map { |l| Ingredient.parse(l) }
end

def solve(input, tsps)
  gen_ratios(input.length, tsps)
    .each_with_object(input)
    .map(&method(:measure))
    .map(&method(:score))
    .max
end

def gen_ratios(n, max)
  (1..max).to_a
    .repeated_permutation(n)
    .lazy
    .select { |p| p.reduce(&:+) == max }
end

def measure(teaspons, ingredients)
  ingredients.zip(teaspons).map {|i,t| i.to_h(t)}
end

SCORABLE_KEYS = %i(capacity durability flavor texture)
def score(amounts)
  calores = amounts.each_with_object(:calories).map(&:fetch).reduce(&:+)
  return 0 unless calores == 500
  SCORABLE_KEYS.reduce(1) do |total, k|
    s = amounts.each_with_object(k).map(&:fetch).reduce(&:+)
    total * [0, s].max
  end
end

class Ingredient
  attr_reader :name, :capacity, :durability, :flavor, :texture, :calories

  def initialize(name, capacity, durability, flavor, texture, calories)
    @name = name
    @capacity = capacity
    @durability = durability
    @flavor = flavor
    @texture = texture
    @calories = calories
  end

  def to_h(amount)
    {
      capacity: capacity * amount,
      durability: durability * amount,
      flavor: flavor * amount,
      texture: texture * amount,
      calories: calories * amount
    }
  end

  def self.parse(line)
    m = line.match(/(\S+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/)

    Ingredient.new(*[m[1]] + m[2..-1].map(&:to_i))
  end
end
