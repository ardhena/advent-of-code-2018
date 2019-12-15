require 'pry'
class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
  end

  def calc_part_1
    Nanofactory.new(@input).produce_fuel(1)
  end

  def calc_part_2(ore_reserves)
    factory = Nanofactory.new(@input)

    (1..ore_reserves).bsearch { |i| factory.produce_fuel(i) > ore_reserves } - 1
  end
end

class Nanofactory
  def initialize(input)
    @reactions = input.map do |reaction|
      input_chemicals, output_chemical = reaction.split(" => ")

      output_quantity, output_chemical = output_chemical.split(" ")

      input_chemicals = input_chemicals.split(", ").map do |input_chemical|
        input_quantity, input_chemical = input_chemical.split(" ")
        [input_quantity.to_i, input_chemical]
      end

      [output_chemical, [output_quantity.to_i, input_chemicals]]
    end.to_h

    @spare_chemicals = @reactions.keys.map{ |chemical| [chemical, 0] }.to_h
  end

  def produce_fuel(quantity)
    ore_for_chemical("FUEL", quantity, *@reactions["FUEL"])
  end

  private

  def ore_for_chemical(chemical, required_quantity, produced_quantity, input_chemicals)
    return 0 if required_quantity == 0

    # take from spare resources
    if @spare_chemicals[chemical] > 0
      taken_from_spare = 
        if @spare_chemicals[chemical] >= required_quantity
          required_quantity
        else
          @spare_chemicals[chemical]
        end

      @spare_chemicals[chemical] -= taken_from_spare
      required_quantity -= taken_from_spare
    end

    number_of_reactions = (required_quantity / produced_quantity.to_f).ceil
    
    # add to spare resources
    total_produced = number_of_reactions * produced_quantity
    @spare_chemicals[chemical] += (total_produced - required_quantity)

    # calculate ore for input chemicals
    input_chemicals.sum do |input_quantity, input_chemical|
      if input_chemical == "ORE"
        number_of_reactions * input_quantity
      else
        ore_for_chemical(input_chemical, number_of_reactions * input_quantity, *@reactions[input_chemical])
      end
    end
  end
end