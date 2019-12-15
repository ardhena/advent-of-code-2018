class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
  end

  def calc_part_1
    Nanofactory.new(@input).produce_fuel
  end

  def calc_part_2
    @input
  end
end

class Nanofactory
  def initialize(input)
    @available_reactions = input.map{ |reaction| Reaction.new(reaction) }
  end

  def produce_fuel
    @input_chemicals = []
    @spare_input_chemicals = []
    fuel_reaction = @available_reactions.find{ |reaction| reaction.produces_fuel? }
    run_reaction(fuel_reaction)

    loop do
      process_input_chemicals
      @input_chemicals = @input_chemicals.reject(&:nil?)

      break if @input_chemicals.size == 1
    end

    @input_chemicals
  end

  private

  def run_reaction(reaction)
    reaction.input_chemicals.each do |chemical|
      i = @input_chemicals.find_index{ |chem| chem&.type == chemical.type }

      if i.nil?
        @input_chemicals += [chemical.dup]
      else
        @input_chemicals[i].change_quantity(@input_chemicals[i].quantity + chemical.quantity)
      end
    end
  end

  def process_input_chemicals
    @input_chemicals.each_with_index do |chemical, i|
      next if chemical.nil?

      reaction_for_input_chemical = @available_reactions.find{ |reaction| reaction.produces?(chemical) }
      next if reaction_for_input_chemical.nil? # must be ore
      
      reaction_number = process_chemical_for_reaction(chemical, reaction_for_input_chemical)
      @input_chemicals[i] = nil
      next if reaction_number == 0

      puts "#{reaction_number} * #{reaction_for_input_chemical}"

      (1..reaction_number).each do |_|
        run_reaction(reaction_for_input_chemical)
      end
    end
  end

  def process_chemical_for_reaction(chemical, reaction)
    spare_chemical = find_spare_chemical(chemical)

    produced_quantity = reaction.output_chemical.quantity
    required_quantity = chemical.quantity - spare_chemical.quantity

    if required_quantity <= 0 # enough spare chemical, doesn't need reaction
      spare_chemical.change_quantity(spare_chemical.quantity - chemical.quantity)
      reaction_number = 0
    else
      spare_chemical.change_quantity(0)
      reaction_number = (required_quantity / produced_quantity.to_f).ceil
      spare_quantity = produced_quantity - required_quantity
      spare_chemical.change_quantity(spare_chemical.quantity + spare_quantity)
    end

    reaction_number
  end

  def find_spare_chemical(chemical)
    i = @spare_input_chemicals.find_index{ |chem| chem&.type == chemical.type }

    return @spare_input_chemicals[i] unless i.nil?
    spare_chemical = chemical.dup
    spare_chemical.change_quantity(0)
    @spare_input_chemicals += [spare_chemical]
    spare_chemical
  end
end

class Reaction
  def initialize(raw_reaction)
    input_chemicals, output_chemical = raw_reaction.split(" => ")
    @input_chemicals = input_chemicals.split(", ").map{ |ic| Chemical.new(ic) }
    @output_chemical = Chemical.new(output_chemical)
  end

  def produces_fuel?
    output_chemical.fuel?
  end

  def produces?(chemical)
    output_chemical.type == chemical.type
  end

  def requires_ore?
    input_chemicals.select{ |chem| chem.ore? }.size > 0
  end

  def requires?(chemical)
    input_chemicals.select{ |chem| chem.type == chemical.type }.size > 0
  end

  def to_s
    # "#<Reaction @input_chemicals=#{input_chemicals.map(&:to_s)}, @output_chemical=#{output_chemical}>"
    "Reaction #{input_chemicals.map(&:to_s).join(", ")} => #{output_chemical}"
  end

  attr_reader :input_chemicals, :output_chemical
end

class Chemical
  FUEL = "FUEL"
  ORE = "ORE"

  def initialize(raw_chemical)
    quantity, @type = raw_chemical.split(" ")
    @quantity = quantity.to_i
  end

  def fuel?
    type == FUEL
  end

  def ore?
    type == ORE
  end

  def change_quantity(new_quantity)
    @quantity = new_quantity
  end

  def to_s
    # "#<Chemical @type=#{type}, @quantity=#{quantity}>"
    "#{quantity} #{type}"
  end

  attr_reader :quantity, :type
end