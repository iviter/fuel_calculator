# frozen_string_literal: true

class Planet
  GRAVITIES = {
    'earth' => 9.807,
    'moon' => 1.62,
    'mars' => 3.711
  }.freeze

  def self.gravity(planet)
    GRAVITIES[planet&.downcase] || raise("Unknown planet: #{planet}")
  end
end
