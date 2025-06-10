# frozen_string_literal: true

require_relative '../../lib/validators/flight_path_validator'

class FlightPathValidatorTest
  def initialize
    @planets = {
      'earth' => 9.807,
      'moon' => 1.62,
      'mars' => 3.711
    }
    @valid_path = [[:launch, 'earth'], [:land, 'moon']]
    @passed = 0
    @failed = 0
  end

  def assert_equal(expected, actual, message)
    if expected == actual
      puts "PASS: #{message}"
      @passed += 1
    else
      puts "FAIL: #{message}. Expected: #{expected.inspect}, Got: #{actual.inspect}"
      @failed += 1
    end
  end

  def run
    test_valid_flight_path_and_integer_mass
    test_valid_flight_path_and_float_mass
    test_invalid_mass_negative
    test_invalid_mass_zero
    test_invalid_mass_nil
    test_invalid_mass_string
    test_invalid_flight_path_non_array
    test_invalid_flight_path_empty_array
    test_invalid_flight_path_nil
    test_invalid_action_in_flight_path
    test_missing_action_in_flight_path
    test_unknown_planet_in_flight_path
    test_case_insensitive_planet_validation
    test_missing_planet_in_flight_path
    test_malformed_flight_path_tuple

    puts "\nTest Summary: #{@passed} passed, #{@failed} failed"
    raise "Tests failed!" if @failed > 0
  end

  def test_valid_flight_path_and_integer_mass
    validator = FlightPathValidator.new(28801, @valid_path, @planets)

    assert_equal(nil, validator.validate, 'Valid integer mass should return nil')
  end

  def test_valid_flight_path_and_float_mass
    validator = FlightPathValidator.new(28801.5, @valid_path, @planets)

    assert_equal(nil, validator.validate, 'Valid float mass should return nil')
  end

  def test_invalid_mass_negative
    validator = FlightPathValidator.new(-100, @valid_path, @planets)

    assert_equal('Invalid mass: must be a positive number', validator.validate, 'Negative mass should return error')
  end

  def test_invalid_mass_zero
    validator = FlightPathValidator.new(0, @valid_path, @planets)

    assert_equal('Invalid mass: must be a positive number', validator.validate, 'Zero mass should return error')
  end

  def test_invalid_mass_nil
    validator = FlightPathValidator.new(nil, @valid_path, @planets)

    assert_equal('Invalid mass: must be a positive number', validator.validate, 'Nil mass should return error')
  end

  def test_invalid_mass_string
    validator = FlightPathValidator.new('100', @valid_path, @planets)

    assert_equal('Invalid mass: must be a positive number', validator.validate, 'String mass should return error')
  end

  def test_invalid_flight_path_non_array
    validator = FlightPathValidator.new(28801, 'not an array', @planets)

    assert_equal('Invalid flight path: must be a non-empty array', validator.validate, 'Non-array flight path should return error')
  end

  def test_invalid_flight_path_empty_array
    validator = FlightPathValidator.new(28801, [], @planets)

    assert_equal('Invalid flight path: must be a non-empty array', validator.validate, 'Empty flight path should return error')
  end

  def test_invalid_flight_path_nil
    validator = FlightPathValidator.new(28801, nil, @planets)

    assert_equal('Invalid flight path: must be a non-empty array', validator.validate, 'Nil flight path should return error')
  end

  def test_invalid_action_in_flight_path
    invalid_path = [[:launch, 'earth'], [:invalid, 'moon']]
    validator = FlightPathValidator.new(28801, invalid_path, @planets)

    assert_equal('Invalid action in step 2: must be :launch or :land', validator.validate, 'Invalid action should return error')
  end

  def test_missing_action_in_flight_path
    invalid_path = [[nil, 'earth'], [:land, 'moon']]
    validator = FlightPathValidator.new(28801, invalid_path, @planets)

    assert_equal('Invalid action in step 1: must be :launch or :land', validator.validate, 'Missing action should return error')
  end

  def test_unknown_planet_in_flight_path
    invalid_path = [[:launch, 'earth'], [:land, 'jupiter']]
    validator = FlightPathValidator.new(28801, invalid_path, @planets)

    assert_equal("Unknown gravity for planet 'jupiter' at step 2", validator.validate, 'Unknown planet should return error')
  end

  def test_case_insensitive_planet_validation
    mixed_case_path = [[:launch, 'Earth'], [:land, 'MOON']]
    validator = FlightPathValidator.new(28801, mixed_case_path, @planets)

    assert_equal(nil, validator.validate, 'Case-insensitive planet names should be valid')
  end

  def test_missing_planet_in_flight_path
    invalid_path = [[:launch, nil], [:land, 'moon']]
    validator = FlightPathValidator.new(28801, invalid_path, @planets)

    assert_equal("Unknown gravity for planet '' at step 1", validator.validate, 'Missing planet should return error')
  end

  def test_malformed_flight_path_tuple
    invalid_path = [[:launch, 'earth'], ['not a tuple', 'moon']]
    validator = FlightPathValidator.new(28801, invalid_path, @planets)

    assert_equal('Invalid action in step 2: must be :launch or :land', validator.validate, 'Malformed tuple should return error')
  end
end

FlightPathValidatorTest.new.run
