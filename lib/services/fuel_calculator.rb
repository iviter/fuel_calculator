# frozen_string_literal: true

require_relative '../validators/flight_path_validator'
require_relative '../models/planet'

class FuelCalculator
  FUEL_CALCULATION_ERROR = 'Error in fuel calculation'
  LAUNCH_FACTOR = 0.042
  LANDING_FACTOR = 0.033
  LAUNCH_OFFSET = 33
  LANDING_OFFSET = 42

  def initialize(mass, flight_path)
    @mass = mass
    @flight_path = flight_path
  end

  def call
    calculate_fuel
  end

  private

  attr_reader :mass, :flight_path

  def calculate_fuel
    return validation_error if validation_error

    accumulate_fuel(mass)
  end

  def validation_error
    FlightPathValidator.new(mass, flight_path, Planet::GRAVITIES).validate
  end

  def accumulate_fuel(initial_mass)
    total_fuel = 0
    current_mass = initial_mass

    flight_path.reverse_each do |action, planet|
      fuel = calculate_fuel_for_step(current_mass, action, planet)
      return FUEL_CALCULATION_ERROR if fuel < 0

      total_fuel += fuel
      current_mass += fuel
    end

    total_fuel
  end

  def calculate_fuel_for_step(mass, action, planet)
    gravity = Planet.gravity(planet)
 
    sum_fuel(mass, action, gravity)
  end
  
  def sum_fuel(mass, action, gravity)
    total_fuel = 0
    fuel = calculate_base_fuel(mass, action, gravity)

    while fuel > 0
      total_fuel += fuel
      fuel = calculate_base_fuel(fuel, action, gravity)
    end

    total_fuel
  end

  def calculate_base_fuel(mass, action, gravity)
    factor = action == :launch ? LAUNCH_FACTOR : LANDING_FACTOR
    offset = action == :launch ? LAUNCH_OFFSET : LANDING_OFFSET

    (mass * gravity * factor - offset).floor
  end
end
