class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split("-").map(&:to_i)
  end

  def calc_part_1
    sum = 0
    (@input[0]..@input[1]).each do |number|
      sum += 1 if fullfils_requirements_for_part_1?(number_to_array(number)) 
    end
    sum
  end

  def calc_part_2
    sum = 0
    (@input[0]..@input[1]).each do |number|
      sum += 1 if fullfils_requirements_for_part_2?(number_to_array(number)) 
    end
    sum
  end

  private

  def number_to_array(number)
    [
      number / 100000, 
      number % 100000 / 10000, 
      number % 10000 / 1000, 
      number % 1000 / 100,
      number % 100 / 10, 
      number % 10
    ]
  end

  def fullfils_requirements_for_part_1?(number)
    no_decreasing_digits(number) && same_adjacent_digits(number)
  end

  def fullfils_requirements_for_part_2?(number)
    no_decreasing_digits(number) && two_same_adjacent_digits(number)
  end

  def no_decreasing_digits(number)
    number == number.sort
  end

  def same_adjacent_digits(number)
    number[0] == number[1] || 
      number[1] == number[2] || 
      number[2] == number[3] || 
      number[3] == number[4] || 
      number[4] == number[5]
  end

  def two_same_adjacent_digits(number)
    (number[0] == number[1] && number[1] != number[2]) || 
      (number[0] != number[1] && number[1] == number[2] && number[2] != number[3]) || 
      (number[1] != number[2] && number[2] == number[3] && number[3] != number[4]) || 
      (number[2] != number[3] && number[3] == number[4] && number[4] != number[5]) || 
      (number[3] != number[4] && number[4] == number[5])
  end
end
