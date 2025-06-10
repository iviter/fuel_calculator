# frozen_string_literal: true

require_relative '../../lib/services/fuel_calculator'

class FuelCalculatorTest
  def initialize
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
    test_apollo_11
    test_mission_on_mars
    test_passenger_ship
    test_invalid_planet
    test_invalid_action
    test_invalid_mass
    test_float_mass
    test_empty_path
    test_nil_mass
    test_nil_flight_path
    test_malformed_flight_path_tuple

    puts "\nTest Summary: #{@passed} passed, #{@failed} failed"
    raise "Tests failed!" if @failed > 0
  end

  def test_apollo_11
    calculator = FuelCalculator.new(28801, [[:launch, 'earth'], [:land, 'moon'], [:launch, 'moon'], [:land, 'earth']])

    assert_equal(51898, calculator.call, 'Apollo 11 should return correct fuel')
  end

  def test_mission_on_mars
    calculator = FuelCalculator.new(14606, [[:launch, 'earth'], [:land, 'mars'], [:launch, 'mars'], [:land, 'earth']])

    assert_equal(33388, calculator.call, 'Mission on Mars should return correct fuel')
  end

  def test_passenger_ship
    calculator = FuelCalculator.new(75432, [[:launch, 'earth'], [:land, 'moon'], [:launch, 'moon'], [:land, 'mars'], [:launch, 'mars'], [:land, 'earth']])
    
    assert_equal(212161, calculator.call, 'Passenger ship should return correct fuel')
  end

  def test_invalid_planet
    calculator = FuelCalculator.new(1000, [[:launch, 'jupiter']])

    assert_equal("Unknown gravity for planet 'jupiter' at step 1", calculator.call, 'Invalid planet should return error')
  end

  def test_invalid_action
    calculator = FuelCalculator.new(1000, [[:invalid, 'earth']])

    assert_equal("Invalid action in step 1: must be :launch or :land", calculator.call, 'Invalid action should return error')
  end

  def test_invalid_mass
    calculator = FuelCalculator.new(-100, [[:launch, 'earth']])

    assert_equal('Invalid mass: must be a positive number', calculator.call, 'Invalid mass should return error')
  end

  def test_float_mass
    calculator = FuelCalculator.new(28801.5, [[:land, 'earth']])

    assert_equal(13448, calculator.call, 'Float mass should return correct fuel')
  end

  def test_empty_path
    calculator = FuelCalculator.new(1000, [])

    assert_equal('Invalid flight path: must be a non-empty array', calculator.call, 'Empty flight path should return error')
  end

  def test_nil_mass
    calculator = FuelCalculator.new(nil, [[:launch, 'earth']])

    assert_equal('Invalid mass: must be a positive number', calculator.call, 'Nil mass should return error')
  end

  def test_nil_flight_path
    calculator = FuelCalculator.new(1000, nil)

    assert_equal('Invalid flight path: must be a non-empty array', calculator.call, 'Nil flight path should return error')
  end

  def test_malformed_flight_path_tuple
    calculator = FuelCalculator.new(1000, [[:launch, 'earth'], ['not a tuple', 'moon']])

    assert_equal('Invalid action in step 2: must be :launch or :land', calculator.call, 'Malformed tuple should return error')
  end
end

FuelCalculatorTest.new.run
