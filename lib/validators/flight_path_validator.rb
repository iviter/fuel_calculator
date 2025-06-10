# frozen_string_literal: true

class FlightPathValidator
  INVALID_MASS_ERROR = 'Invalid mass: must be a positive number'
  INVALID_PATH_ERROR = 'Invalid flight path: must be a non-empty array'
  VALID_ACTIONS = %i[launch land]

  def initialize(mass, flight_path, planets)
    @mass = mass
    @flight_path = flight_path
    @planets = planets
  end

  def validate
    return INVALID_MASS_ERROR unless valid_mass?
    return INVALID_PATH_ERROR unless valid_flight_path?

    validate_steps
  end

  private

  attr_reader :mass, :flight_path, :planets

  def valid_mass?
    mass.is_a?(Numeric) && mass > 0
  end

  def valid_flight_path?
    flight_path.is_a?(Array) && !flight_path.empty?
  end

  def validate_steps
    flight_path.each_with_index do |(action, planet), index|
      unless VALID_ACTIONS.include?(action)
        return "Invalid action in step #{index + 1}: must be :launch or :land"
      end
      unless planets.key?(planet&.downcase)
        return "Unknown gravity for planet '#{planet}' at step #{index + 1}"
      end
    end

    nil
  end
end
