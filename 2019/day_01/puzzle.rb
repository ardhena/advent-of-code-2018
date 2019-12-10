class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).map(&:to_i)
  end

  def calc_part_1
    @input.sum{ |module_mass| required_fuel(module_mass) }
  end

  def calc_part_2
    @input.sum{ |module_mass| required_fuel_for_fuel(required_fuel(module_mass)) }
  end

  private

  def required_fuel(module_mass)
    (module_mass / 3.0).floor - 2
  end

  def required_fuel_for_fuel(mass)
    return 0 if mass < 0
    mass + required_fuel_for_fuel(required_fuel(mass))
  end
end