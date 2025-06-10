# Fuel Calculator

A Ruby application designed for NASA to calculate the fuel required for space missions based on a spacecraft's mass and flight path. The application supports missions involving launches and landings on Earth, Moon, and Mars, accounting for gravitational differences and cumulative fuel requirements.

## Features

- Calculates fuel for complex mission flight paths (for example Apollo 11, Mars missions).
- Validates inputs for mass, flight path, and planet gravities.
- Handles case-insensitive planet names (for example "Earth", "MOON").
- Returns precise error messages for invalid inputs.
- Built with plain Ruby, no external frameworks, ensuring simplicity and reliability.

## Prerequisites

- Ruby
- Rake (install via `gem install rake`)

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/iviter/fuel_calculator
   cd fuel_calculator
   ```

## Running Tests

Tests are organized in subdirectories mirroring the `lib/` structure and use plain Ruby without frameworks. Run all tests with:

```bash
rake test
```

## Usage

The `FuelCalculator` class calculates fuel based on mass and a flight path array of `[action, planet]` tuples, where action is `:launch` or `:land`, and planet is `"earth"`, `"moon"`, or `"mars"`.

**Example (Apollo 11 mission):**

```ruby
calculator = FuelCalculator.new(28801, [
  [:launch, 'earth'],
  [:land, 'moon'],
  [:launch, 'moon'],
  [:land, 'earth']
])

fuel = calculator.call
puts fuel  # Outputs: 51898
```

**Error Handling:**

```ruby
calculator = FuelCalculator.new(-100, [[:launch, 'earth']])
puts calculator.call  # Outputs: Invalid mass: must be a positive number
```
