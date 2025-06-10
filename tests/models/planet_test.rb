# frozen_string_literal: true

require_relative '../../lib/models/planet'

class PlanetTest
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

  def assert_raises(expected_message, message)
    begin
      yield
      puts "FAIL: #{message}. Expected to raise: #{expected_message.inspect}"
      @failed += 1
    rescue StandardError => e
      if e.message == expected_message
        puts "PASS: #{message}"
        @passed += 1
      else
        puts "FAIL: #{message}. Expected error: #{expected_message.inspect}, Got: #{e.message.inspect}"
        @failed += 1
      end
    end
  end

  def run
    test_gravity_for_earth
    test_gravity_for_moon
    test_gravity_for_mars
    test_case_insensitive_planet_name
    test_unknown_planet
    test_nil_planet
    test_empty_string_planet

    puts "\nTest Summary: #{@passed} passed, #{@failed} failed"
    raise "Tests failed!" if @failed > 0
  end

  def test_gravity_for_earth
    assert_equal(9.807, Planet.gravity('earth'), 'Should return gravity for Earth')
  end

  def test_gravity_for_moon
    assert_equal(1.62, Planet.gravity('moon'), 'Should return gravity for Moon')
  end

  def test_gravity_for_mars
    assert_equal(3.711, Planet.gravity('mars'), 'Should return gravity for Mars')
  end

  def test_case_insensitive_planet_name
    assert_equal(9.807, Planet.gravity('Earth'), 'Should handle case-insensitive Earth')
    assert_equal(1.62, Planet.gravity('MOON'), 'Should handle case-insensitive Moon')
    assert_equal(3.711, Planet.gravity('MaRs'), 'Should handle case-insensitive Mars')
  end

  def test_unknown_planet
    assert_raises('Unknown planet: jupiter', 'Should raise error for unknown planet') do
      Planet.gravity('jupiter')
    end
  end

  def test_nil_planet
    assert_raises('Unknown planet: ', 'Should raise error for nil planet') do
      Planet.gravity(nil)
    end
  end

  def test_empty_string_planet
    assert_raises('Unknown planet: ', 'Should raise error for empty string planet') do
      Planet.gravity('')
    end
  end
end

PlanetTest.new.run
