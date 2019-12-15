require 'pry'

class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
  end

  def calc_part_1(steps)
    orbit = JupiterOrbit.new(@input)
    orbit.simulate_time_steps(steps)
  end

  def calc_part_2
    orbit = JupiterOrbit.new(@input)
    history = orbit.log_time_step([[], [], []])

    300000.times do
      orbit.simulate_time_step
      history = orbit.log_time_step(history)
    end

    periods = []
    history.each_with_index do |axis_history, _|
      axis_period = axis_history.each_index
                                .select{|i| axis_history[i] == axis_history[0]}[1]
                                # [1] because [0] is a starting history event
      periods << axis_period
    end
    periods.inject(:lcm)
  end
end

class JupiterOrbit
  def initialize(moons_data)
    @moons = 
      moons_data.map do |moon_data|
        x, y, z = moon_data.gsub(">", "")
                           .gsub("<", "")
                           .split(", ")
                           .map{ |coord| coord[2..-1].to_i }
        Moon.new([x, y, z])
      end
  end

  def simulate_time_steps(steps)
    (1..steps).map{ |step| simulate_time_step }
  end

  def simulate_time_step
    total_energy = 0
    prev_moons = @moons.map{ |m| Marshal.load(Marshal.dump(m)) }

    @moons.each do |moon|
      moon.apply_gravity(prev_moons - [moon])
      moon.apply_velocity

      total_energy += moon.total_energy
    end

    total_energy
  end

  def log_time_step(history)
    history.each_with_index do |_, i|
      axis_history = @moons.flat_map do |moon|
        [moon.position[i], moon.velocity[i]]
      end

      history[i] << axis_history
    end

    history
  end

  attr_reader :moons
end

class Moon
  def initialize(position)
    @position = position
    @velocity = [0, 0, 0]
  end

  def apply_gravity(other_moons)
    other_moons.each do |other_moon|
      @velocity[0] += pull_moons_together_on_axis(other_moon, 0)
      @velocity[1] += pull_moons_together_on_axis(other_moon, 1)
      @velocity[2] += pull_moons_together_on_axis(other_moon, 2)
    end
  end

  def apply_velocity
    @position[0] += velocity[0]
    @position[1] += velocity[1]
    @position[2] += velocity[2]
  end 

  def total_energy
    potential_energy = position.sum{ |pos| pos.abs }
    kinetic_energy = velocity.sum{ |pos| pos.abs }
    potential_energy * kinetic_energy
  end 

  attr_reader :position, :velocity

  private

  def pull_moons_together_on_axis(other_moon, axis)
    return 1 if position[axis] < other_moon.position[axis]
    return -1 if position[axis] > other_moon.position[axis]
    0
  end
end